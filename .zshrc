# Path to your oh-my-zsh installation.
export ZSH=/Users/arnoschutijzer/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="vleesbrood"
# ZSH_THEME="avit"
# ZSH_THEME="avit-white"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
export UPDATE_ZSH_DAYS=1

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

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
plugins=(git brew npm git-flow nvm)

# User configuration

export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$HOME/.cargo/bin:$PATH"
# export MANPATH="/usr/local/man:$MANPATH"

source $ZSH/oh-my-zsh.sh

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
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

alias showf='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app'
alias hidef='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app'
alias a='atom .'
alias httpserver='python -m SimpleHTTPServer'
alias clean_mod='find . -name node_modules -type d -exec rm -rf {} +'
i() { echo "installing... $*\n"; npm install $*}
id() { echo "installing w/ devdep $*\n"; npm install --save-dev $*}
r() { echo "running $*\n"; npm run $*}
gpf() { echo "pushing --force-with-lease"; git push --force-with-lease $* }
tdeploy() { /Users/arnoschutijzer/ngrok $*; }
ytdl() {
  youtube-dl -x --audio-format=mp3 --no-playlist -o "$1.%(ext)s" $2;
  touch \$downloaded.txt;
  echo "$1" >> \$downloaded.txt;
  echo "successfully wrote to disk at $(pwd)";
}
nocors() { open -n -a /Applications/Google\ Chrome.app --args --user-data-dir="/tmp/someFolderName" --disable-web-security }
help() {
  echo "
  i: npm install,
  \nid: npm install --save-dep,
  \nis: npm install --save,
  \nud: npm uninstall --save-dep,
  \nus: npm uninstall --save,
  \nr: npm run,
  \nshowf: show dotfiles,
  \nhidef: hide dotfiles,
  \na: open atom,
  \nhttpserver: python -m SimpleHttpServer,
  \nclean_mod: find <path> -name node_modules -type d exec trash {} +";
}
function code {
    if [[ $# = 0 ]]
    then
        open -a "Visual Studio Code"
    else
        local argPath="$1"
        [[ $1 = /* ]] && argPath="$1" || argPath="$PWD/${1#./}"
        open -a "Visual Studio Code" "$argPath"
    fi
}
#add z
. `brew --prefix`/etc/profile.d/z.sh
export NVM_DIR="/Users/arnoschutijzer/.nvm"
export JAVA_HOME=$(/usr/libexec/java_home)
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
export PATH="/usr/local/sbin:$PATH"

# tabtab source for serverless package
# uninstall by removing these lines or running `tabtab uninstall serverless`
[[ -f /Users/arnoschutijzer/.nvm/versions/node/v7.9.0/lib/node_modules/serverless/node_modules/tabtab/.completions/serverless.zsh ]] && . /Users/arnoschutijzer/.nvm/versions/node/v7.9.0/lib/node_modules/serverless/node_modules/tabtab/.completions/serverless.zsh
# tabtab source for sls package
# uninstall by removing these lines or running `tabtab uninstall sls`
[[ -f /Users/arnoschutijzer/.nvm/versions/node/v7.9.0/lib/node_modules/serverless/node_modules/tabtab/.completions/sls.zsh ]] && . /Users/arnoschutijzer/.nvm/versions/node/v7.9.0/lib/node_modules/serverless/node_modules/tabtab/.completions/sls.zsh