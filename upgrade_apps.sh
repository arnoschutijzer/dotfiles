#!/bin/zsh

# Put brew on PATH for this script.
eval "$(/opt/homebrew/bin/brew shellenv)"

brew upgrade --greedy --yes && brew cleanup

# brew clears the sudo timestamp on every invocation, so nothing can hold sudo
# across the upgrade. This prompts, and a keepalive here cannot prevent it.
sudo mas upgrade
