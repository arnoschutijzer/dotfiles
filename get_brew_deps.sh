#!/bin/zsh
brew bundle dump --no-go
brew bundle --no-upgrade --cleanup

mv Brewfile ./configuration
