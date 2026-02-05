#!/bin/zsh
ln -sf "$(pwd)"/configuration/.tflint.hcl ~/.tflint.hcl
tflint --init

mkdir -p ~/.config/zed/
ln -sf "$(pwd)"/configuration/zed/settings.json ~/.config/zed/settings.json

touch ~/.terraformrc
CACHE_PATH="$HOME/.terraform.d/plugin-cache"
echo "plugin_cache_dir   = \"$CACHE_PATH\"" > ~/.terraformrc

mkdir -p $CACHE_PATH

# Claude Code: ensure Serena MCP server is configured
CLAUDE_JSON="$HOME/.claude.json"
if [ -f "$CLAUDE_JSON" ]; then
  HAS_SERENA=$(jq 'has("mcpServers") and (.mcpServers | has("serena"))' "$CLAUDE_JSON")
  if [ "$HAS_SERENA" != "true" ]; then
    jq '.mcpServers.serena = {
      "type": "stdio",
      "command": "uvx",
      "args": ["--from", "git+https://github.com/oraios/serena", "serena", "start-mcp-server", "--context=claude-code", "--project-from-cwd"],
      "env": {}
    }' "$CLAUDE_JSON" > "$CLAUDE_JSON.tmp" && mv "$CLAUDE_JSON.tmp" "$CLAUDE_JSON"
    echo "Added Serena MCP server to Claude Code config"
  fi
else
  echo "~/.claude.json not found, skipping Serena MCP setup (run Claude Code once first)"
fi
