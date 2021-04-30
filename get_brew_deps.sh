#!/bin/zsh
brew leaves > brew-dependencies.txt
brew ls --cask >> brew-dependencies.txt
