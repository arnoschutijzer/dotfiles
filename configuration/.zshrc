export ZSH="/Users/arnoschutijzer/.oh-my-zsh"

export PATH=/Applications:$PATH
export PATH=/Users/arnoschutijzer/bin:$PATH
export GPG_TTY=$(tty)

export STARSHIP_CONFIG=~/.starship.toml
eval "$(starship init zsh)"

plugins=(
  git z macos ssh-agent zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh

# Aliases
alias clean_mod='find . -name node_modules -type d -exec rm -r {} +'
alias dka='docker kill $(docker ps -q)'
alias dup='docker compose up -d'
alias flushdns='sudo killall -HUP mDNSResponder;sudo killall mDNSResponderHelper'
alias awsv=aws-vault
alias ag=rg
alias sed=gsed
alias idea='open -na "IntelliJ IDEA CE.app" --args "$@"'
alias i='idea .'
alias openssl1='/opt/homebrew/Cellar/openssl@1.1/1.1.1w/bin/openssl'
alias ga.='ga .'
alias ls=eza

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
  yt-dlp -x --audio-format=mp3 --no-playlist -o "$1.%(ext)s" $2 --cookies-from-browser firefox --cookies ~/Downloads/cookies.txt;
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

export GOPATH="${HOME}/.go"
export PATH="$PATH:${GOPATH}/bin"
eval "$(mise activate zsh)"

[[ -f ~/dotfiles/.secrets ]] && source ~/dotfiles/.secrets
