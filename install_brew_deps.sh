#!/bin/zsh
cd configuration

brew bundle

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
