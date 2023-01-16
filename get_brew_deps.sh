#!/bin/zsh
brew bundle dump
brew bundle --cleanup

mv Brewfile ./configuration