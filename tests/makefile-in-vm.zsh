#!/bin/zsh

# Runs the makefile phases on a throwaway macOS VM, so a full setup can be
# tested without touching this machine. The VM is a tart clone of a clean base
# image, deleted again when the run ends.
#
# Usage:  tests/makefile-in-vm.zsh [target ...]      (default: bootstrap apps configure)
# Env:    TART_IMAGE, TART_VM, KEEP_VM=1, OPEN_SHELL=1, BOOT_TIMEOUT,
#         TARGET_TIMEOUT, DISK_SIZE
#
# OPEN_SHELL=1 opens a login shell in the VM instead of running the phases, and
# is what `make vm` uses. Name targets as well to get both, the phases first and
# the shell after. The VM goes away when the shell exits, unless KEEP_VM=1.
#
# bootstrap stops on its own, because it wants a Proton Pass session the VM does
# not have. That is the expected result of an unattended run, not a broken
# script. The Mac App Store entries are skipped instead: mas waits for a signed
# in account and never returns, and a hang tells nobody anything.

emulate -L zsh
set -u

local repo="${0:A:h:h}"  # this script lives in <repo>/tests

local image="${TART_IMAGE:-ghcr.io/cirruslabs/macos-sequoia-base:latest}"
local vm="${TART_VM:-dotfiles-test-$$}"
local guest_user=admin
local guest_password=admin
local boot_timeout="${BOOT_TIMEOUT:-300}"
local target_timeout="${TARGET_TIMEOUT:-5400}"
local keep_vm="${KEEP_VM:-0}"
local open_shell="${OPEN_SHELL:-0}"
# The base image holds 50 GB, of which the Brewfile fills the last 400 MB and
# then casks start to fail. 120 GB leaves room. The clone is copy on write, so
# the host only pays for what the run writes.
local disk_size="${DISK_SIZE:-120}"

local -a targets
targets=("$@")
(( $# || open_shell )) || targets=(bootstrap apps configure)

local work_dir="$(mktemp -d /tmp/dotfiles-vm-test.XXXXXX)"
local key="$work_dir/id_ed25519"
local guest_ip=""
local vm_pid=""

typeset -i failures=0

pass() { print -r -- "PASS: $1" }
fail() { print -r -- "FAIL: $1"; (( failures += 1 )) }
info() { print -r -- "--- $1" }

cleanup() {
  if (( keep_vm )); then
    info "KEEP_VM set. VM '$vm' left running at ${guest_ip:-unknown ip}, key in $key"
    return
  fi
  info "Deleting VM '$vm'."
  tart stop "$vm" > /dev/null 2>&1
  [[ -n "$vm_pid" ]] && kill "$vm_pid" 2> /dev/null
  tart delete "$vm" > /dev/null 2>&1
}
trap cleanup EXIT INT TERM

# Every ssh call goes to a machine that lives for one run, so a host key is of
# no use and a known_hosts entry would collide with the next run's VM.
local -a ssh_options
ssh_options=(-o StrictHostKeyChecking=no -o IdentitiesOnly=yes -o UserKnownHostsFile=/dev/null -o LogLevel=ERROR)

guest() { ssh -i "$key" "$ssh_options[@]" "$guest_user@$guest_ip" "$@" }

require_tart() {
  if ! command -v tart > /dev/null 2>&1; then
    fail "tart is not installed. Run: brew install openai/tools/tart"
    exit 1
  fi
}

start_vm() {
  info "Cloning $image into '$vm'."
  if ! tart clone "$image" "$vm"; then
    fail "could not clone $image"
    exit 1
  fi

  tart set "$vm" --disk-size "$disk_size"

  info "Booting '$vm' headless."
  tart run --no-graphics "$vm" > "$work_dir/vm.log" 2>&1 &
  vm_pid=$!

  guest_ip=$(tart ip "$vm" --wait "$boot_timeout" 2>/dev/null)
  if [[ -z "$guest_ip" ]]; then
    fail "VM did not report an IP within ${boot_timeout}s (log: $work_dir/vm.log)"
    exit 1
  fi
  info "VM has IP $guest_ip."
}

wait_for_ssh() {
  local -i waited=0
  while (( waited < boot_timeout )); do
    nc -z -G 2 "$guest_ip" 22 > /dev/null 2>&1 && return 0
    sleep 2
    (( waited += 2 ))
  done
  fail "ssh on $guest_ip did not open within ${boot_timeout}s"
  exit 1
}

# The base image takes a password only. One expect run trades it for a
# throwaway key, so the rest of the script needs no interactive terminal.
install_key() {
  ssh-keygen -q -t ed25519 -N '' -C dotfiles-vm-test -f "$key"
  expect > /dev/null 2>&1 <<EXPECT
    set timeout 60
    spawn ssh-copy-id -i "$key.pub" -o IdentitiesOnly=yes -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=ERROR $guest_user@$guest_ip
    expect "assword:"
    send "$guest_password\r"
    expect eof
EXPECT

  if ! guest -o BatchMode=yes true; then
    fail "key authentication to $guest_user@$guest_ip failed"
    exit 1
  fi
}

# The scripts call sudo from a shell with no terminal, where a password prompt
# reads EOF and the phase stops. Two lines are needed in the disposable VM, not
# one. NOPASSWD covers the commands; !authenticate covers `sudo -v`, which
# sudo_keepalive.sh calls and which authenticates as long as one rule in
# /etc/sudoers still asks for a password. Mode 0440 is not cosmetic either:
# sudo ignores a drop-in that any other user can write, and says nothing.
grant_passwordless_sudo() {
  local drop_in=/etc/sudoers.d/dotfiles-test
  local rules="Defaults:$guest_user !authenticate\n$guest_user ALL=(ALL) NOPASSWD: ALL\n"

  guest "echo '$guest_password' | sudo -S sh -c 'printf \"$rules\" > $drop_in && chmod 0440 $drop_in'" 2> /dev/null

  if ! guest 'sudo -v' < /dev/null > /dev/null 2>&1; then
    fail "sudo still asks for a password in the VM; every phase that calls sudo would stop"
    exit 1
  fi
}

# macOS grows the APFS container to the new disk on its own at boot. The resize
# is a fallback for an image that does not, and reports "must be different than
# the existing size" when the boot already did the work. The trailing space in
# the pattern keeps the small Apple_APFS_ISC partition out of the match.
grow_guest_disk() {
  local container
  container=$(guest "diskutil list physical | awk '/Apple_APFS / { print \$NF }' | head -1" < /dev/null)
  guest "sudo diskutil apfs resizeContainer $container 0" < /dev/null > /dev/null 2>&1

  local free
  free=$(guest "df -g /System/Volumes/Data | awk 'NR == 2 { print \$4 }'" < /dev/null)
  info "Guest has ${free}G free on the data volume."
}

# The working tree, not the commit: the point is to test the scripts as they
# are on disk. .git stays behind because none of the phases read it.
copy_repo() {
  info "Copying the working tree to ~/dotfiles in the VM."
  tar -c -C "$repo" --exclude .git --exclude .serena -f - . \
    | guest "rm -rf ~/dotfiles && mkdir -p ~/dotfiles && tar -x -f - -C ~/dotfiles"
}

# brew bundle skips a Mac App Store entry whose id is in this list. The ids come
# from the Brewfile itself, so an entry added later is skipped too.
mas_skip_list() {
  awk '/^mas / { gsub(/[^0-9]/, "", $NF); print $NF }' "$repo/configuration/Brewfile" | tr '\n' ' '
}

# stdin is /dev/null on purpose: generate_git_config.sh and the Homebrew
# installer both read from it, and an EOF makes them skip instead of hang.
# The watchdog is for the hangs that stdin cannot prevent, such as an installer
# waiting on a window that a headless VM never shows.
run_target() {
  local target="$1"
  local log="$work_dir/$target.log"
  info "make $target (log: $log)"

  guest "cd ~/dotfiles && HOMEBREW_BUNDLE_MAS_SKIP='$(mas_skip_list)' make $target" \
    > "$log" 2>&1 < /dev/null &
  local session=$!

  local -i waited=0
  while (( waited < target_timeout )) && kill -0 "$session" 2> /dev/null; do
    sleep 10
    (( waited += 10 ))
  done

  if kill -0 "$session" 2> /dev/null; then
    kill "$session" 2> /dev/null
    fail "make $target made no progress within ${target_timeout}s"
    tail -n 20 "$log" | sed -e 's/^/    /'
    return
  fi

  wait "$session"
  local -i exit_code=$?

  if (( exit_code == 0 )); then
    pass "make $target"
  else
    fail "make $target exited $exit_code"
    tail -n 20 "$log" | sed -e 's/^/    /'
  fi
}

# -t asks for a terminal, which the phases do not want and a person does. The
# working tree is already in ~/dotfiles, so make runs here as well.
open_guest_shell() {
  info "Opening a login shell in '$vm' as $guest_user. Leave it to end the run."
  ssh -i "$key" "$ssh_options[@]" -t "$guest_user@$guest_ip" 'cd ~/dotfiles && exec zsh -l'
}

require_tart
start_vm
wait_for_ssh
install_key
grant_passwordless_sudo
grow_guest_disk
copy_repo

local target
for target in "$targets[@]"; do
  run_target "$target"
done

(( open_shell )) && open_guest_shell

info "Logs: $work_dir"
exit $(( failures > 0 ))
