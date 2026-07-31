#!/bin/zsh

# Make runs this before the shell config is linked, so brew is not on PATH yet.
eval "$(/opt/homebrew/bin/brew shellenv)"

mkdir -p ~/.config/mise
ln -sf "$(pwd)"/configuration/mise/config.toml ~/.config/mise/config.toml
mise install
