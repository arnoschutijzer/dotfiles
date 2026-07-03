#!/bin/zsh

# Tests for the zsh startup split. Each test spawns a fresh clean-env zsh so
# the result depends on the startup files under ~, not on the current shell.

emulate -L zsh
set -u

typeset -i failures=0

pass() { print -r -- "PASS: $1" }
fail() { print -r -- "FAIL: $1"; (( failures += 1 )) }

# A bare non-interactive, non-login shell: what an agent or script gets.
bare() { env -i HOME="$HOME" TERM=xterm zsh -c "$1" 2>/dev/null }

test_bare_resolves_toolchain() {
  local probe missing
  probe='for t in mise node eza; do command -v $t >/dev/null || print missing-cmd:$t; done; case :$PATH: in (*:$HOME/bin:*) ;; (*) print missing-path:bin ;; esac'
  missing=$(bare "$probe")
  if [[ -z "$missing" ]]; then
    pass "bare non-interactive shell resolves mise, node, eza and has ~/bin on PATH"
  else
    fail "bare non-interactive shell is missing: ${missing//$'\n'/, }"
  fi
}

test_guard_skips_cosmetics_when_non_interactive() {
  local result
  result=$(bare 'source ~/.zshrc >/dev/null 2>&1; print -r -- ${aliases[ls]:-GUARD_RETURNED_EARLY}')
  if [[ "$result" == "GUARD_RETURNED_EARLY" ]]; then
    pass "sourcing .zshrc in a non-interactive shell returns before defining cosmetics"
  else
    fail "non-interactive .zshrc did not guard; alias ls resolved to '$result'"
  fi
}

test_bare_resolves_toolchain
test_guard_skips_cosmetics_when_non_interactive

exit $(( failures > 0 ))
