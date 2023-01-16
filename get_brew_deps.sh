#!/bin/zsh
brew bundle dump
brew bundle --no-upgrade --cleanup

mv Brewfile ./configuration
mv Brewfile.lock.json ./configuration
