#!/bin/zsh
# Link shared agent config (global instructions + settings) into every harness home.
# Local config lives under configuration/agents/.

set -eu

REPO="${0:A:h}"
AGENTS_DIR="$REPO/configuration/agents"

install_link() {
  local target="$1"
  local destination="$2"
  local managed_root="$3"

  if [[ ! -e "$destination" && ! -L "$destination" ]]; then
    ln -s "$target" "$destination"
    return
  fi

  [[ -L "$destination" ]] || {
    print -u2 -- "Skipping user-owned path: $destination"
    return
  }

  local existing_target="$(readlink "$destination")"
  [[ "$existing_target" == "$target" ]] && return

  # A link outside managed_root is normally someone else's file. But if it's
  # also dangling, it can't be user content either — most likely it's ours
  # from before the repo moved, so heal it instead of leaving it broken.
  # Test the link itself: a relative target resolves from the link's directory.
  if [[ "$existing_target" != "$managed_root"/* ]] && [[ -e "$destination" ]]; then
    print -u2 -- "Skipping unmanaged link: $destination"
    return
  fi

  unlink "$destination"
  ln -s "$target" "$destination"
}

mkdir -p ~/.claude ~/.codex

# Global instructions: read by Claude as CLAUDE.md and by Codex as AGENTS.md.
# Claude does not read AGENTS.md at any scope, so a project needs a CLAUDE.md
# that imports it with @AGENTS.md.
install_link "$AGENTS_DIR/AGENTS.md" ~/.claude/CLAUDE.md "$AGENTS_DIR"
install_link "$AGENTS_DIR/AGENTS.md" ~/.codex/AGENTS.md "$AGENTS_DIR"

# Claude-specific settings.
install_link "$REPO/configuration/.claude/settings.json" ~/.claude/settings.json "$REPO/configuration/.claude"
