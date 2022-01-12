brew tap beeftornado/rmtree
brew tap bridgecrewio/airiam https://github.com/bridgecrewio/airiam

while read p; do
  brew install "$p"
done < "$(pwd)"/configuration/brew-dependencies.txt

# assuming these are all installed by this point...
osascript -e 'tell application "System Events" to make login item at end with properties {path:"/Applications/iTerm.app", hidden:true}'
osascript -e 'tell application "System Events" to make login item at end with properties {path:"/Applications/Slack.app", hidden:true}'
osascript -e 'tell application "System Events" to make login item at end with properties {path:"/Applications/ShiftIt.app", hidden:true}'
osascript -e 'tell application "System Events" to make login item at end with properties {path:"/Applications/OpenVPN Connect.app", hidden:true}'
