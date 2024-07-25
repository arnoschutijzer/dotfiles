# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/Users/arnoschutijzer/.oh-my-zsh"

# Add applications to path
export PATH=/Applications:$PATH
export PATH=/opt/homebrew/opt/python/libexec/bin:$PATH
# add the custom bin folder
export PATH=/Users/arnoschutijzer/bin:$PATH
# add golang
export GOPATH="${HOME}/.go"
export GOROOT="$(brew --prefix golang)/libexec"
export PATH="$PATH:${GOPATH}/bin:${GOROOT}/bin"
export GPG_TTY=$(tty)

export STARSHIP_CONFIG=~/.starship.toml
eval "$(starship init zsh)"

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
# ZSH_THEME="gitster"

# Set list of themes to load
# Setting this variable when ZSH_THEME=random
# cause zsh load theme from this variable instead of
# looking in ~/.oh-my-zsh/themes/
# An empty array have no effect
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git z macos ssh-agent zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# clean node_modules from the current directory down
alias clean_mod='find . -name node_modules -type d -exec rm -r {} +'
alias clean_pkg='find . -name package-lock.json -type f -exec rm {} +'
alias clean_yarn='find . -name yarn.lock -type f -exec rm {} +'
alias clean_tf='find . -name .terraform -type d -exec rm -rf {} +'
alias clean_tg='find . -name .terragrunt-cache -type d -exec rm -rf {} +'
alias clean='clean_mod && clean_yarn && clean_pkg'
alias dka='docker kill $(docker ps -q)'
alias dup='docker-compose up -d'
alias flushdns='sudo killall -HUP mDNSResponder;sudo killall mDNSResponderHelper'
alias tf=terraform
alias tfd=terraform-docs
alias awsv=aws-vault
alias ag=rg
alias tflock='terraform providers lock -platform=linux_amd64'
alias sed=gsed
alias idea='open -a "`ls -dt /Applications/IntelliJ\ IDEA*|head -1`"'
alias i='idea .'
# see https://github.com/OpenVPN/openvpn3/issues/139#issuecomment-1215125756
alias vpn='sudo /Library/Frameworks/OpenVPNConnect.framework/Versions/Current/usr/sbin/ovpnagent'
alias openssl1='/opt/homebrew/Cellar/openssl@1.1/1.1.1w/bin/openssl'
alias ga.='ga .'
alias venv='python3 -m venv .venv && source .venv/bin/activate'

function agpg {
  GPG_EMAIL=$(git config user.email)
  GPG_KEY=$(gpg --list-secret-keys --keyid-format LONG $GPG_EMAIL | awk '/sec/{print $2}' | cut -d'/' -f 2)
  git config user.signingkey $GPG_KEY
  git config commit.gpgsign true
  echo "$GPG_KEY has been added to the repository associated with $GPG_EMAIL"
  unset GPG_EMAIL
  unset GPG_KEY
}

# start npm commands with r <command>
function r {
    echo "running $*\n";
    npm run $*
}

# usage: ytdl "hello world" https://youtube.url.here
function ytdl() {
  yt-dlp -x --audio-format=mp3 --no-playlist -o "$1.%(ext)s" $2;
  echo "successfully wrote to disk at $(pwd)";
}

function set_protonmail() {
  git config user.email "arno.schutijzer@protonmail.com"
}

function rewrite_commits() {
    git filter-branch -f --env-filter '
CORRECT_NAME="Arno Schutijzer"
CORRECT_EMAIL="arno.schutijzer@protonmail.com"

if [ "$GIT_COMMITTER_EMAIL" != "$CORRECT_EMAIL" ]
then
    export GIT_COMMITTER_NAME="$CORRECT_NAME"
    export GIT_COMMITTER_EMAIL="$CORRECT_EMAIL"
fi
if [ "$GIT_AUTHOR_EMAIL" != "CORRECT_EMAIL" ]
then
    export GIT_AUTHOR_NAME="$CORRECT_NAME"
    export GIT_AUTHOR_EMAIL="$CORRECT_EMAIL"
fi
' --tag-name-filter cat -- --branches --tags
}

# Environment variables
export NVM_DIR="$HOME/.nvm"
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && . "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && . "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

load-nvmrc() {
  local nvmrc_path
  nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version
    nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$(nvm version)" ]; then
      nvm use
    fi
  elif [ -n "$(PWD=$OLDPWD nvm_find_nvmrc)" ] && [ "$(nvm version)" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}

add-zsh-hook chpwd load-nvmrc
load-nvmrc
# place this after nvm initialization!
autoload -U add-zsh-hook

# Set libuv threadpool, change this if webpack hangs
export UV_THREADPOOL_SIZE=1000

export NODE_OPTIONS=--max_old_space_size=8192

export PATH="$HOME/.jenv/bin:$PATH"
eval "$(jenv init -)"

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
