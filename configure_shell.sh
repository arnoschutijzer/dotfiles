#!/bin/zsh

ln -sf "$(pwd)"/configuration/ghostty-configuration ~/Library/Application\ Support/com.mitchellh.ghostty/config

# see https://ohmyz.sh/#install
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

ln -sf "$(pwd)"/configuration/starship.toml ~/.starship.toml

ln -sf "$(pwd)"/configuration/.zshrc ~/.zshrc
ln -sf "$(pwd)"/configuration/.zprofile ~/.zprofile

ln -sf "$(pwd)"/configuration/.vimrc ~/.vimrc

touch ~/.secrets
