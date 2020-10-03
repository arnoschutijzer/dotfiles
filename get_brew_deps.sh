#!/bin/zsh
brew leaves > brew-dependencies.txt
echo "# brew casks" >> brew-dependencies.txt
brew ls --cask >> brew-dependencies.txt
