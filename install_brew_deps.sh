#!/bin/zsh

# Homebrew arrives in the bootstrap phase, which must run first.
if ! command -v /opt/homebrew/bin/brew > /dev/null 2>&1; then
  echo "Homebrew is missing. Run: make bootstrap"
  exit 1
fi

# Put brew on PATH for this script. Make runs it before the shell config is linked.
eval "$(/opt/homebrew/bin/brew shellenv)"

# Cask installers with a pkg payload call sudo on their own, long after the
# bundle starts. Only ask when the bundle has work to do, so a configured
# machine reruns make without a password.
if ! brew bundle check --file=configuration/Brewfile > /dev/null 2>&1; then
    . ./sudo_keepalive.sh
fi

cd configuration

brew bundle

# assuming these are all installed by this point...
osascript -e 'tell application "System Events" to make login item at end with properties {path:"/Applications/Ghostty.app", hidden:true}'
osascript -e 'tell application "System Events" to make login item at end with properties {path:"/Applications/Raycast.app", hidden:true}'
osascript -e 'tell application "System Events" to make login item at end with properties {path:"/Applications/Slack.app", hidden:true}'
