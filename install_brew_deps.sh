#!/bin/zsh

# Bootstrap Homebrew on a fresh machine. Its installer pulls in the Xcode
# Command Line Tools that the formulae below build against.
if ! command -v brew > /dev/null 2>&1; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Put brew on PATH for this script. Make runs it before the shell config is linked.
eval "$(/opt/homebrew/bin/brew shellenv)"

cd configuration

brew bundle

# Xcode arrives from the mas entries above with its license unaccepted, which
# makes every xcodebuild call fail until someone agrees to it.
if [ -d /Applications/Xcode.app ] && ! xcodebuild -version > /dev/null 2>&1; then
  sudo xcodebuild -license accept
fi

# assuming these are all installed by this point...
osascript -e 'tell application "System Events" to make login item at end with properties {path:"/Applications/Ghostty.app", hidden:true}'
osascript -e 'tell application "System Events" to make login item at end with properties {path:"/Applications/Raycast.app", hidden:true}'
osascript -e 'tell application "System Events" to make login item at end with properties {path:"/Applications/Slack.app", hidden:true}'
