#!/bin/zsh
# Link shared agent config (skills + global instructions) into every harness home.
# One source under configuration/agents/, read by Claude, Codex, and any .agents-aware harness.

REPO="$(pwd)"
AGENTS_DIR="$REPO/configuration/agents"

mkdir -p ~/.claude/skills ~/.agents/skills ~/.codex

# Global instructions: read by Claude as CLAUDE.md and by Codex as AGENTS.md.
ln -sf "$AGENTS_DIR/AGENTS.md" ~/.claude/CLAUDE.md
ln -sf "$AGENTS_DIR/AGENTS.md" ~/.codex/AGENTS.md

# Claude-specific settings.
ln -sf "$REPO/configuration/.claude/settings.json" ~/.claude/settings.json

# Skills: each linked into the harness skill dirs that read them.
for skill_path in "$AGENTS_DIR"/skills/*/; do
  skill_name="$(basename "$skill_path")"
  for skills_dir in ~/.claude/skills ~/.agents/skills; do
    rm -rf "$skills_dir/$skill_name"
    ln -sf "${skill_path%/}" "$skills_dir/$skill_name"
  done
done
