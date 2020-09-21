# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/Users/arnoschutijzer/.oh-my-zsh"

# Add applications to path
export PATH=/Applications:$PATH
# Add python to path
export PATH=/Users/arnoschutijzer/Library/Python/2.7/bin:$PATH
# Add python3
export PATH=/Users/arnoschutijzer/Library/Python/3.7/bin:$PATH
# add the custom bin folder
export PATH=/Users/arnoschutijzer/bin:$PATH

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="gitster"
eval "$(starship init zsh)"

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
  git z osx ssh-agent
)

source $ZSH/oh-my-zsh.sh

# User configuration

# activate autosuggestions, see https://github.com/zsh-users/zsh-autosuggestions/
source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh

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
alias clean_mod='find . -name node_modules -type d -exec rm -rf {} +'
alias clean_pkg='find . -name package-lock.json -type f -exec rm {} +'
alias clean_yarn='find . -name yarn.lock -type f -exec rm {} +'
alias clean_tg='find . -name .terragrunt-cache -type d -exec rm -rf {} +'
alias clean='clean_mod $$ clean_yarn && clean_pkg'
alias wttr='curl wttr.in'
alias ..='cd ..'
alias dka='docker kill $(docker ps -q)'
alias dup='docker-compose up -d'
alias expose='ssh -R 80:localhost:8080 ssh.localhost.run'
alias flushdns='sudo killall -HUP mDNSResponder;sudo killall mDNSResponderHelper'
alias tf=terraform
alias tg=terragrunt
alias tfd=terraform-docs
alias really_prune_branches="git branch --merged | grep -v "master" >/tmp/merged-branches && vi /tmp/merged-branches && xargs git branch -d </tmp/merged-branches && rm /tmp/merged-branches"
alias awsv=aws-vault

# start npm commands with r <command>
function r {
    echo "running $*\n";
    npm run $*
}

function ytdl() {
  youtube-dl -x --audio-format=mp3 --no-playlist -o "$1.%(ext)s" $2;
  touch \$downloaded.txt;
  echo "$1" >> \$downloaded.txt;
  echo "successfully wrote to disk at $(pwd)";
}

# Environment variables
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Set libuv threadpool, change this if webpack hangs
export UV_THREADPOOL_SIZE=1000

export NODE_OPTIONS=--max_old_space_size=8192

export JAVA_HOME=$(/usr/libexec/java_home)

export UNSPLASH_API_KEY=xxx
export UNBG_CACHE_PATH=/Users/arnoschutijzer/Pictures/unbg-cache
export TFE_TOKEN=xxx

export PATH="$HOME/.jenv/bin:$PATH"
eval "$(jenv init -)"