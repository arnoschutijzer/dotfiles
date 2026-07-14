# Environment for every shell, interactive or not, login or not.
# Kept here rather than in .zshrc so non-interactive shells (agent-run
# commands, scripts) resolve the same tools a terminal does.

typeset -U path PATH  # keep entries unique, so re-sourcing never grows PATH

# Homebrew. Absolute path so this works before brew is on PATH.
eval "$(/opt/homebrew/bin/brew shellenv)"

path=("$HOME/bin" /Applications $path)

export GOPATH="$HOME/.go"
path=($path "$GOPATH/bin")

# mise-managed runtimes (node, java, maven, terraform, go)
eval "$(mise activate zsh)"

[[ -f ~/dotfiles/.secrets ]] && source ~/dotfiles/.secrets

# Snapshot the built PATH so a login shell can restore this order after macOS
# path_helper reorders it, without re-running the brew/mise setup above (.zprofile).
DOTFILES_PATH=$PATH

# uv
export PATH="/Users/arnoschutijzer/.local/bin:$PATH"
