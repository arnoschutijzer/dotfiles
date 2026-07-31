#!/bin/zsh

ln -sf "$(pwd)"/configuration/.gitignore_global ~
ln -sf "$(pwd)"/configuration/.gitconfig ~

git lfs install

echo "See README.md to set up additional git user configuration."
