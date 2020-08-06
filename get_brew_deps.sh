#!/bin/zsh
brew leaves > brew-dependencies.txt
echo "# brew casks" >> brew-dependencies.txt
brew cask ls >> brew-dependencies.txt

