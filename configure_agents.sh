#!/bin/zsh
# Link shared agent config (skills + global instructions) into every harness home.
# Local config lives under configuration/agents/; external skills use the skills CLI.

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

remove_stale_skill_links() {
  local skills_dir="$1"

  # Remove only dangling links. Test the link itself, not its readlink text:
  # the skills CLI writes relative targets, which resolve from the link's
  # directory rather than the current one.
  for destination in "$skills_dir"/*(N@); do
    [[ -e "$destination" ]] || unlink "$destination"
  done
}

install_external_skills() {
  local source="$1"
  shift
  local agent skill_name skill_path
  local -A agent_skill_dirs=(
    codex "$HOME/.agents/skills"
    claude-code "$HOME/.claude/skills"
  )

  # Check each agent's skill dir on its own, so a skill present for one agent
  # still gets installed for the other.
  for agent in ${(k)agent_skill_dirs}; do
    local -a missing_skills=()
    for skill_name in "$@"; do
      skill_path="${agent_skill_dirs[$agent]}/$skill_name"
      if [[ -e "$skill_path" || -L "$skill_path" ]]; then
        print -- "Skipping existing skill for $agent: $skill_name"
        continue
      fi
      missing_skills+=("$skill_name")
    done

    (( ${#missing_skills} > 0 )) || continue

    npx --yes skills add "$source" --global --yes \
      --agent "$agent" --skill "${missing_skills[@]}"
  done
}

mkdir -p ~/.claude/skills ~/.agents/skills ~/.codex

remove_stale_skill_links ~/.claude/skills
remove_stale_skill_links ~/.agents/skills

# Global instructions: read by Claude as CLAUDE.md and by Codex as AGENTS.md.
# Claude does not read AGENTS.md at any scope, so a project needs a CLAUDE.md
# that imports it with @AGENTS.md.
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

install_external_skills mattpocock/skills \
  prototype research wayfinder grill-me grilling grill-with-docs tdd setup-matt-pocock-skills
install_external_skills vercel-labs/skills find-skills
