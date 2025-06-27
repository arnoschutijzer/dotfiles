#!/bin/zsh
cd configuration

brew bundle

jenv enable-plugin maven

# assuming these are all installed by this point...
osascript -e 'tell application "System Events" to make login item at end with properties {path:"/Applications/Ghostty.app", hidden:true}'
osascript -e 'tell application "System Events" to make login item at end with properties {path:"/Applications/Raycast.app", hidden:true}'
osascript -e 'tell application "System Events" to make login item at end with properties {path:"/Applications/Slack.app", hidden:true}'
