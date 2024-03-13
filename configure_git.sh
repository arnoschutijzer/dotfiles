#!/bin/zsh

ln -sf "$(pwd)"/configuration/.gitignore_global ~

git config --global core.excludesfile ~/.gitignore_global

git lfs install
