#!/bin/zsh
brew bundle dump --no-go
brew bundle --no-upgrade

mv Brewfile ./configuration
