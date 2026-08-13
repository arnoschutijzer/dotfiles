#!/bin/zsh
# Link shared agent config (skills + global instructions) into every harness home.
# One source under configuration/agents/, read by Claude, Codex, and any .agents-aware harness.

set -eu

REPO="${0:A:h}"
AGENTS_DIR="$REPO/configuration/agents"

assert_installable_link() {
  local target="$1"
  local destination="$2"
  local managed_root="$3"

  [[ ! -e "$destination" && ! -L "$destination" ]] && return
  [[ -L "$destination" ]] || {
    print -u2 -- "Refusing to replace user-owned path: $destination"
    return 1
  }

  local existing_target="$(readlink "$destination")"
  [[ "$existing_target" == "$target" ]] && return
  [[ "$existing_target" == "$managed_root"/* ]] || {
    print -u2 -- "Refusing to replace unmanaged link: $destination"
    return 1
  }
}

install_link() {
  local target="$1"
  local destination="$2"

  [[ -L "$destination" && "$(readlink "$destination")" == "$target" ]] && return
  [[ -L "$destination" ]] && unlink "$destination"
  ln -s "$target" "$destination"
}

remove_stale_skill_links() {
  local skills_dir="$1"

  for destination in "$skills_dir"/*(N@); do
    local target="$(readlink "$destination")"
    [[ "$target" == "$AGENTS_DIR/skills/"* ]] || continue
    [[ -d "$target" ]] && continue
    unlink "$destination"
  done
}

mkdir -p ~/.claude/skills ~/.agents/skills ~/.codex

assert_installable_link "$AGENTS_DIR/AGENTS.md" ~/.claude/CLAUDE.md "$AGENTS_DIR"
assert_installable_link "$AGENTS_DIR/AGENTS.md" ~/.codex/AGENTS.md "$AGENTS_DIR"
assert_installable_link "$REPO/configuration/.claude/settings.json" ~/.claude/settings.json "$REPO/configuration/.claude"

for skill_path in "$AGENTS_DIR"/skills/*/; do
  skill_name="$(basename "$skill_path")"
  for skills_dir in ~/.claude/skills ~/.agents/skills; do
    assert_installable_link "${skill_path%/}" "$skills_dir/$skill_name" "$AGENTS_DIR/skills"
  done
done

remove_stale_skill_links ~/.claude/skills
remove_stale_skill_links ~/.agents/skills

# Global instructions: read by Claude as CLAUDE.md and by Codex as AGENTS.md.
install_link "$AGENTS_DIR/AGENTS.md" ~/.claude/CLAUDE.md
install_link "$AGENTS_DIR/AGENTS.md" ~/.codex/AGENTS.md

# Claude-specific settings.
install_link "$REPO/configuration/.claude/settings.json" ~/.claude/settings.json

# Skills: each linked into the harness skill dirs that read them.
for skill_path in "$AGENTS_DIR"/skills/*/; do
  skill_name="$(basename "$skill_path")"
  for skills_dir in ~/.claude/skills ~/.agents/skills; do
    install_link "${skill_path%/}" "$skills_dir/$skill_name"
  done
done
