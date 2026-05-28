#!/bin/zsh

# thanks to https://github.com/mustafa-turk/.dotfiles/blob/master/macos.sh

# show hidden files by default
defaults write com.apple.finder AppleShowAllFiles -bool true

# disable creation of .DS_store
defaults write com.apple.desktopservices DSDontWriteNetworkStores true

# speeds up the animation when trying hiding/showing dock
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0.5

# automatically hide and show dock
defaults write com.apple.dock autohide -bool true

# make cursor move faster
defaults write NSGlobalDomain KeyRepeat -int 1
defaults write NSGlobalDomain InitialKeyRepeat -int 10

# assuming these are all installed by this point...
add_login_item() {
  local name=$1 path=$2
  local exists=$(osascript -e "tell application \"System Events\" to (login item \"$name\" exists)")
  if [ "$exists" = "false" ]; then
    osascript -e "tell application \"System Events\" to make login item at end with properties {path:\"$path\", hidden:true}"
  fi
}

add_login_item "Ghostty" "/Applications/Ghostty.app"
add_login_item "Raycast" "/Applications/Raycast.app"
add_login_item "Slack" "/Applications/Slack.app"
