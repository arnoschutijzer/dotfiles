# Environment for every shell, interactive or not, login or not.
# Kept here rather than in .zshrc so non-interactive shells (agent-run
# commands, scripts) resolve the same tools a terminal does.

typeset -U path PATH  # keep entries unique, so re-sourcing never grows PATH

# Homebrew. Absolute path so this works before brew is on PATH.
eval "$(/opt/homebrew/bin/brew shellenv)"

path=("$HOME/bin" /Applications $path)

export GOPATH="$HOME/.go"
path=($path "$GOPATH/bin")

# Local tools, including uv and Hermes.
path=("$HOME/.local/bin" $path)

# Keep mise-managed runtimes ahead of other tools, including inherited paths.
export MISE_ACTIVATE_AGGRESSIVE=1
eval "$(mise activate zsh)"

# Snapshot the built PATH so a login shell can restore this order after macOS
# path_helper reorders it, without re-running the brew/mise setup above (.zprofile).
DOTFILES_PATH=$PATH
