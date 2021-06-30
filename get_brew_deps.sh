#!/bin/zsh
brew leaves > "$(pwd)"/configuration/brew-dependencies.txt
brew ls --cask >> "$(pwd)"/configuration/brew-dependencies.txt
