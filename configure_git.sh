#!/bin/zsh

ln -sf "$(pwd)"/.gitignore_global ~

git config --global core.excludesfile ~/.gitignore_global
