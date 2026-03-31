#!/bin/zsh

mkdir -p ~/.config/mise
ln -sf "$(pwd)"/configuration/mise/config.toml ~/.config/mise/config.toml
mise install
