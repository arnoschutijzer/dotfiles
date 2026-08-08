#!/bin/zsh

# Put brew on PATH for this script.
eval "$(/opt/homebrew/bin/brew shellenv)"

# A greedy upgrade rebuilds casks whose installers call sudo, and mas needs it
# outright. Both land well past the five minute timestamp, so hold it here.
. ./sudo_keepalive.sh

brew upgrade --greedy --yes && brew cleanup
sudo mas upgrade
