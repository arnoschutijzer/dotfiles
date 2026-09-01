#!/bin/zsh
# Link shared agent config (skills + global instructions) into every harness home.
# One source under configuration/agents/, read by Claude, Codex, and any .agents-aware harness.

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
  if [[ "$existing_target" != "$managed_root"/* ]] && [[ -e "$existing_target" ]]; then
    print -u2 -- "Skipping unmanaged link: $destination"
    return
  fi

  unlink "$destination"
  ln -s "$target" "$destination"
}

remove_stale_skill_links() {
  local skills_dir="$1"

  for destination in "$skills_dir"/*(N@); do
    local target="$(readlink "$destination")"
    if [[ "$target" == "$AGENTS_DIR/skills/"* ]]; then
      [[ -d "$target" ]] && continue
    elif [[ -e "$target" ]]; then
      continue
    fi
    unlink "$destination"
  done
}

mkdir -p ~/.claude/skills ~/.agents/skills ~/.codex

remove_stale_skill_links ~/.claude/skills
remove_stale_skill_links ~/.agents/skills

# Global instructions: read by Claude as CLAUDE.md and by Codex as AGENTS.md.
install_link "$AGENTS_DIR/AGENTS.md" ~/.claude/CLAUDE.md "$AGENTS_DIR"
install_link "$AGENTS_DIR/AGENTS.md" ~/.codex/AGENTS.md "$AGENTS_DIR"

# Claude-specific settings.
install_link "$REPO/configuration/.claude/settings.json" ~/.claude/settings.json "$REPO/configuration/.claude"

# Skills: each linked into the harness skill dirs that read them.
for skill_path in "$AGENTS_DIR"/skills/*/; do
  skill_name="$(basename "$skill_path")"
  for skills_dir in ~/.claude/skills ~/.agents/skills; do
    install_link "${skill_path%/}" "$skills_dir/$skill_name" "$AGENTS_DIR/skills"
  done
done
