# Plan: Restructure into layered, per-tool setup scripts

**Branch**: chore/restructure-setup-scripts **Status**: Active

## Goal

Reorganise the flat `install_*`/`configure_*`/`generate_*` scripts into one
per-tool/domain `setup_*.sh` script each, so the repo reads as **base tools
first → per-tool install-on-top → configuration of that tool** — and make every
script safely re-runnable.

## Design decisions (approved)

- **Every step is backwards compatible** (expand-migrate-contract). The Makefile
  keeps `apps` and `configure` as **deprecated aliases** delegating to
  `base`/`setup`, so `make`, `make apps`, and `make configure` keep working at
  every commit. Until a script is migrated, its old call stays inside
  `base`/`setup`, so `make all` always runs a complete provision. Script renames
  are atomic (`git mv` + Makefile repoint in one commit); old script *names* are
  **not** shimmed (they're internal, not a public interface). A single final
  **contract** step removes the aliases.
- **Idempotency is fixed first** (Phase 1), on the current scripts, *before* the
  restructure relocates them. Cheaper to fix correct-once than to chase across
  renamed files later, and it keeps the relocation a pure byte-for-byte move of
  already-hardened code.
- **The base layer is `homebrew` then `mise`.** `go`, `java`, `maven`, `node`,
  and `terraform` come from **mise**, not brew (the Brewfile only has the
  hashicorp tap + the VS Code terraform extension). So mise is a base *provider*,
  not a leaf tool: it must run right after Homebrew, because `setup_go.sh`'s
  `go install` and the terraform tooling depend on the runtimes `mise install`
  populates. The mise *binary* itself comes from brew, so `.zshrc`'s
  `mise activate` is always satisfied.
- **Brewfile stays a single file = layer-1 of the base.** `setup_homebrew.sh`
  runs `brew bundle`. No fragment splitting, no `instance_eval`. All existing
  brew workflows (`dump`, `cleanup`, `upgrade`) keep working unchanged.
- **Grouping is per-tool/domain**, expressed in the scripts. The three-layer
  order (install-on-top → configure) lives *inside* each `setup_*.sh`.
- **`configuration/` file locations are unchanged** (out of scope — would churn
  every symlink path for no real gain). Optional follow-up.
- Scripts stay **flat in the repo root**, matching today's style.

## Idempotency

**Invariant: every script reachable from `make all` must be safe to re-run** — a
second `make` on an already-provisioned machine converges to the same state and
adds no duplicates. (CLAUDE.md already mandates non-destructive scripts; this
makes it explicit and testable.)

Most operations are already idempotent and stay that way under pure relocation:

| Operation | Idempotent? | Why |
|---|---|---|
| `ln -sf` (all symlinks) | ✅ | force-overwrites to the same target |
| `brew bundle` | ✅ | installs missing, skips present |
| `mkdir -p`, `touch` | ✅ | no-op if already there |
| `defaults write` | ✅ | sets a value |
| `mise install`, `tflint --init`, `git lfs install`, `git config --global` | ✅ | converge to same state |
| `go install …@<ver>` | ✅ | pinned version; reinstall is effectively a no-op |
| serena `jq` block, `.terraformrc` `>` write | ✅ | overwrite same key/content (jq guarded by `[ -f ]`) |
| `generate_git_config.sh` identities | ✅ | already guarded with `if [ -f ]` |

**Two gaps** — both behavioural, fixed up front in Phase 1 on the current
scripts:

1. **Login items duplicate on every run.** `osascript … make login item at end`
   (in `install_brew_deps.sh`) appends unconditionally → Ghostty/Raycast/Slack
   are re-added each `make`.
2. **oh-my-zsh install is interactive and can clobber `.zshrc`.** The installer
   in `configure_shell.sh` prompts and, without flags, backs up/replaces
   `.zshrc`.

## Acceptance criteria

- [ ] `make all` is idempotent: a second run adds no duplicate login items,
      leaves `~/.zshrc` a repo symlink, and otherwise changes nothing (Phase 1).
- [ ] `make`, `make apps`, and `make configure` keep working as a full provision
      at every commit; `apps`/`configure` are removed only in the contract step.
- [ ] `make all` runs `setup_homebrew.sh` then `setup_mise.sh` (base) then every
      `setup_*.sh` in a sensible order; no `install_*`/`configure_*` script names
      remain (Phase 2).
- [ ] Each tool/domain has exactly one `setup_*.sh` that both installs its
      on-top pieces and symlinks/writes its config.
- [ ] Every symlink/install command is byte-for-byte preserved from its origin
      (the Phase-1-hardened scripts) — only relocated/regrouped (Phase 2).
- [ ] Every script passes `zsh -n` (syntax check).
- [ ] `make help`, `make deps`, `make upgrade`, `make cleanup` still work.
- [ ] `CLAUDE.md` describes the new layout accurately.
- [ ] `.zshrc` is a slim loader that `source`s per-tool fragments from `~/.zsh/`,
      each owned by the matching `setup_*.sh`; a fresh interactive shell behaves
      identically to before (Phase 3).

## Target script set

| New script           | Layer | Replaces / absorbs                                  | Does (install-on-top → config) |
|----------------------|-------|-----------------------------------------------------|--------------------------------|
| `setup_homebrew.sh`  | base  | `install_brew_deps.sh` (brew bundle part)           | `brew bundle` |
| `setup_mise.sh`      | base  | `configure_mise.sh`                                 | symlink `config.toml` → `mise install` (go/java/maven/node/terraform) |
| `setup_go.sh`        | setup | `install_go_deps.sh`                                | `go install …` — **needs mise's go** |
| `setup_terraform.sh` | setup | tflint/terraformrc parts of `configure_tools.sh`    | `tflint --init` → symlink `.tflint.hcl`, write `.terraformrc` cache |
| `setup_macos.sh`     | setup | `configure_mac.sh` + (hardened) login items         | `defaults write …`, guarded login items |
| `setup_git.sh`       | setup | `generate_git_config.sh` + `configure_git.sh`       | identities → symlink gitconfig/ignore, `git lfs install` |
| `setup_shell.sh`     | setup | `configure_shell.sh` (minus `.vimrc`)               | guarded oh-my-zsh → symlink zsh/zprofile/starship/ghostty, `.secrets` |
| `setup_editors.sh`   | setup | `.vimrc` (from shell) + zed (from `configure_tools`)| symlink `.vimrc`, zed settings |
| `setup_claude.sh`    | setup | claude/serena parts of `configure_tools.sh`         | serena MCP in `.claude.json` → symlink claude settings + CLAUDE.md |
| `setup_fonts.sh`     | setup | `install_fonts.sh`                                  | download + install fonts |

Helpers (not in `make all`): `generate_gpg.sh` (kept), and `get_brew_deps.sh`
renamed → `dump_brew_deps.sh` (backs `make deps`).

## Makefile target shape

Final shape (after the contract step):

```make
all: base setup

base:           # foundation: package managers + runtimes
	. ./setup_homebrew.sh   # brew binaries: mise, starship, tflint, eza…
	. ./setup_mise.sh       # mise install → go, java, maven, node, terraform

setup:          # per-tool, each does its own install-on-top → config
	. ./setup_go.sh         # `go install` — needs mise's go
	. ./setup_terraform.sh  # tflint plugins; terraform from mise
	. ./setup_macos.sh
	. ./setup_git.sh
	. ./setup_shell.sh      # .zshrc activates mise (binary already present)
	. ./setup_editors.sh
	. ./setup_claude.sh
	. ./setup_fonts.sh
```

During Phase 2, the Makefile additionally carries the deprecated aliases and a
shrinking mix of not-yet-migrated old scripts:

```make
apps: base          # deprecated alias — removed in the contract step
configure: setup    # deprecated alias — removed in the contract step
```

`deps`/`upgrade`/`cleanup`/`help` targets unchanged.

## Phase 1 — idempotency hardening (steps 1–2)

Fix the two non-idempotent operations on the **current** scripts, before any
relocation. Each step's "test" is **run the operation twice and assert the
second run is a no-op**.

### Step 1: Dedupe login items in `install_brew_deps.sh`

**Change**: Replace the three unconditional `make login item at end` calls with a
guard that reads existing login-item names once and adds only those absent (app
names: `Ghostty`, `Raycast`, `Slack`). **Verify**: run the block twice;
`osascript -e 'tell application "System Events" to get the name of every login
item'` lists each app exactly once. **Done when**: a second run adds no
duplicates.

### Step 2: Make oh-my-zsh install idempotent in `configure_shell.sh`

**Change**: Guard the installer on `[ ! -d ~/.oh-my-zsh ]` and run it with
`--unattended` plus `KEEP_ZSHRC=yes RUNZSH=no`, so it never prompts and never
touches the symlinked `.zshrc`. **Verify**: a second run is a no-op and
`~/.zshrc` stays a symlink into the repo (`readlink ~/.zshrc`). **Done when**:
re-running leaves the `.zshrc` symlink intact.

## Phase 2 — restructure scripts (steps 3–13)

Relocate the (now-hardened) scripts into per-tool `setup_*.sh`. Each step's
"test": **`zsh -n` passes on touched scripts, the Makefile still parses
(`make -n all apps configure`), and every relocated command is byte-for-byte
identical to its origin.** Each step is one commit that leaves a **full**
`make all`/`apps`/`configure` runnable: step 3 stands up `base`/`setup` (plus the
`apps`/`configure` aliases) calling a mix of new `setup_*.sh` and the remaining
old scripts; each later step swaps exactly one old call for its new `setup_*.sh`.
`configure_tools.sh` is drained across steps 8–10 and deleted only once empty.

### Step 3: Base — Homebrew + new target structure

**Change**: Create `setup_homebrew.sh` = the full body of `install_brew_deps.sh`
(`brew bundle` + the Phase-1-hardened login-item block, which transits here until
step 5); delete `install_brew_deps.sh`. Restructure the Makefile to `all: base
setup` with deprecated aliases `apps: base` and `configure: setup`; `base` calls
`setup_homebrew.sh` then the still-old `configure_mise.sh`, and `setup` calls the
remaining old scripts in the new grouping/order — so `make all`/`apps`/`configure`
all run a complete provision. **Verify**: `zsh -n`; `make -n all apps configure
base setup` all parse; `brew bundle` + login lines unchanged. **Done when**:
`install_brew_deps.sh` gone; old targets still work as aliases.

### Step 4: Base — mise (elevated to base layer)

**Change**: Rename `configure_mise.sh` → `setup_mise.sh` (content identical) and
add it to the `base` target **after** `setup_homebrew.sh`, so the
go/java/maven/node/terraform runtimes exist before any leaf script runs. Repoint
Makefile. **Verify**: `zsh -n`; `make -n base`; `mise install` + symlink
unchanged. **Done when**: `configure_mise.sh` gone, `base` runs homebrew then
mise.

### Step 5: macOS

**Change**: Create `setup_macos.sh` = `configure_mac.sh` body + the hardened
login-item block moved out of `setup_homebrew.sh` (where it transited since step
3). Repoint the `setup` body's `configure_mac.sh` line to `setup_macos.sh`;
delete `configure_mac.sh`. **Verify**: `zsh -n`; `make -n setup`; `defaults` +
login-item commands match the Phase-1 versions. **Done when**: `configure_mac.sh`
gone, `setup_homebrew.sh` is back to just `brew bundle`, login items live in
`setup_macos.sh`.

### Step 6: Git

**Change**: Create `setup_git.sh` = `generate_git_config.sh` body followed by
`configure_git.sh` body (generate identities → symlink → `git lfs install`).
Repoint Makefile; delete both originals. **Verify**: `zsh -n`; symlink +
`git config` lines unchanged. **Done when**: both originals gone.

### Step 7: Shell

**Change**: Create `setup_shell.sh` from `configure_shell.sh` (carrying the
Phase-1 oh-my-zsh guard) **minus** the `.vimrc` symlink (goes to editors in step
8). Repoint Makefile; delete `configure_shell.sh`. **Verify**: `zsh -n`;
oh-my-zsh guard + remaining symlinks unchanged. **Done when**: original gone,
`.vimrc` line not yet anywhere (added in step 8).

### Step 8: Editors

**Change**: Create `setup_editors.sh` with the `.vimrc` symlink + the zed
`mkdir`/symlink lines (lifted from `configure_tools.sh`). Repoint Makefile;
remove the zed lines from `configure_tools.sh`. **Verify**: `zsh -n`; both
symlinks present exactly once. **Done when**: zed lines no longer in
`configure_tools.sh`.

### Step 9: Terraform

**Change**: Create `setup_terraform.sh` with the `tflint --init` + `.tflint.hcl`
symlink + `.terraformrc`/plugin-cache lines from `configure_tools.sh`. Repoint
Makefile; remove those lines from `configure_tools.sh`. **Verify**: `zsh -n`;
commands byte-for-byte. **Done when**: terraform lines gone from
`configure_tools.sh`.

### Step 10: Claude

**Change**: Create `setup_claude.sh` with the serena `jq` block + claude
`settings.json`/`CLAUDE.md` symlinks from `configure_tools.sh`. Repoint
Makefile; remove those lines — `configure_tools.sh` is now empty, delete it.
**Verify**: `zsh -n`; `make -n setup`; `configure_tools.sh` gone. **Done when**:
`configure_tools.sh` deleted.

### Step 11: Go

**Change**: Rename `install_go_deps.sh` → `setup_go.sh` (content identical).
Repoint Makefile so it runs in `setup` (after the base mise step from step 4,
which provides `go`). **Verify**: `zsh -n`; `make -n setup`. **Done when**: old
name gone.

### Step 12: Fonts

**Change**: Rename `install_fonts.sh` → `setup_fonts.sh` (content identical).
Repoint Makefile. **Verify**: as above. **Done when**: old name gone.

### Step 13: Docs

**Change**: Update `CLAUDE.md` (Orchestration + Conventions sections) to
describe `base` then per-tool `setup_*.sh`. Rename `get_brew_deps.sh` →
`dump_brew_deps.sh` and repoint the `deps` target at it. **Verify**:
`make -n all deps upgrade cleanup help` all parse. **Done when**: Phase-2
acceptance criteria all checked.

## Phase 3 — split `.zshrc` into sourced fragments (steps 14–19)

Turn the monolithic `.zshrc` into a slim loader that `source`s per-tool
fragments, each owned by the matching `setup_*.sh`. This **changes** `.zshrc`
(so it is deliberately separate from Phase 2's byte-for-byte relocation).

**Mechanism**: fragments live in `configuration/zsh/*.zsh` and are symlinked into
`~/.zsh/` by their owner script (each owner does `mkdir -p ~/.zsh` first, since
owner scripts may run before `setup_shell.sh`). The loader uses an **explicit,
guarded, ordered list** so load order is visible and a not-yet-installed
fragment is skipped:

```zsh
for f in git go terraform editors aliases mise; do
  [[ -f ~/.zsh/$f.zsh ]] && source ~/.zsh/$f.zsh
done
```

Placed after `source $ZSH/oh-my-zsh.sh`, before the `.secrets` line. `mise` is
last (needs `GOPATH`/`PATH` from `go.zsh`). The `.secrets` line is left
untouched (dormant, harmless under its guard).

**Fragment ownership**:

| Fragment            | Owner            | Contents |
|---------------------|------------------|----------|
| `git.zsh`           | `setup_git.sh`   | `GPG_TTY`, `agpg`, `set_protonmail`, `rewrite_commits` |
| `go.zsh`            | `setup_go.sh`    | `GOPATH` + `PATH` append |
| `terraform.zsh`     | `setup_terraform.sh` | `alias tf=terraform` |
| `editors.zsh`       | `setup_editors.sh` | `idea`, `i`, `ned` |
| `aliases.zsh`       | `setup_shell.sh` | generic/base-tool aliases (`clean_mod`, `dka`, `dup`, `flushdns`, `ga.`, `ls=eza`, `ag=rg`, `sed=gsed`, `awsv`, `openssl1`) + `r` npm function |
| `mise.zsh`          | `setup_mise.sh`  | `eval "$(mise activate zsh)"` |

Per-step "test": `zsh -n configuration/.zshrc` + a fresh interactive shell
confirms the moved alias/function/env is present (e.g.
`zsh -ic 'whence -w agpg; alias tf'`).

### Step 14: Loader scaffold + extract git fragment

**Change**: Add the guarded `for`-loop (full list above) to `.zshrc` after the
oh-my-zsh source; create `configuration/zsh/git.zsh` with the git block; remove
that block from `.zshrc`; add `mkdir -p ~/.zsh` + symlink of `git.zsh` to
`setup_git.sh`. **Verify**: `zsh -ic 'whence -w agpg && echo $GPG_TTY'` works.
**Done when**: git block gone from `.zshrc`, loop present.

### Step 15: Extract go fragment

**Change**: Move `GOPATH`/`PATH` lines into `configuration/zsh/go.zsh`; add
`mkdir -p ~/.zsh` + symlink to `setup_go.sh`; remove from `.zshrc`.
**Verify**: `zsh -ic 'echo $GOPATH'`. **Done when**: lines gone from `.zshrc`.

### Step 16: Extract terraform fragment

**Change**: Move `alias tf=terraform` into `configuration/zsh/terraform.zsh`;
symlink from `setup_terraform.sh`; remove from `.zshrc`.
**Verify**: `zsh -ic 'alias tf'`. **Done when**: alias gone from `.zshrc`.

### Step 17: Extract editors fragment

**Change**: Move `idea`/`i`/`ned` aliases into `configuration/zsh/editors.zsh`;
symlink from `setup_editors.sh`; remove from `.zshrc`.
**Verify**: `zsh -ic 'alias idea ned'`. **Done when**: aliases gone from `.zshrc`.

### Step 18: Extract aliases fragment

**Change**: Move remaining generic aliases + the `r` npm function into
`configuration/zsh/aliases.zsh`; `setup_shell.sh` does `mkdir -p ~/.zsh` +
symlinks `aliases.zsh` (and continues to own the loader `.zshrc`); remove from
`.zshrc`. **Verify**: `zsh -ic 'alias ls; whence -w r'`. **Done when**: only the
loader scaffold (omz/starship/path/loop/secrets) remains in `.zshrc`.

### Step 19: Extract mise fragment

**Change**: Move `eval "$(mise activate zsh)"` into `configuration/zsh/mise.zsh`;
symlink from `setup_mise.sh`; remove from `.zshrc`. **Verify**:
`zsh -ic 'whence mise && which node'` resolves via mise shims. **Done when**:
`.zshrc` is the pure loader; Phase-3 acceptance criterion met.

## Contract (step 20)

The deprecation window is over — remove the backwards-compat shims.

### Step 20: Remove deprecated `apps`/`configure` aliases

**Change**: Delete the `apps:` and `configure:` alias targets from the Makefile.
`make all` (= `base setup`) and the per-phase targets remain. **Verify**:
`make -n all base setup deps upgrade cleanup help` parse; `make -n apps` now
fails (expected). **Done when**: only the new target names remain.

## Quality gate (before merge)

1. `zsh -n` on every `setup_*.sh` and on `configuration/.zshrc`.
2. `make -n all base setup deps upgrade cleanup help` all parse without error
   (and `apps`/`configure` too, until step 20 removes them).
3. Diff-audit: every symlink/install/`defaults`/`jq` command matches its origin
   verbatim (grep old vs new), allowing for the Phase-1 idempotency guards.
4. No `install_*` / `configure_*` script names remain (except intentional
   helpers).
5. Phase 3: confirm a fresh `zsh -ic` shell resolves every moved
   alias/function/env (`agpg`, `tf`, `idea`, `ned`, `ls`, `r`, `$GOPATH`, mise
   shims) exactly as before.
6. Idempotency: run `make all` twice — the second run adds no duplicate login
   items and leaves `~/.zshrc` a repo symlink.

---

_Delete this file when the plan is complete. If `plans/` is empty, delete the
directory._
