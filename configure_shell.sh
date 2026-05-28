#!/bin/zsh

ln -sf "$(pwd)"/configuration/ghostty-configuration ~/Library/Application\ Support/com.mitchellh.ghostty/config

# see https://ohmyz.sh/#install
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  RUNZSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

ln -sf "$(pwd)"/configuration/starship.toml ~/.starship.toml

ln -sf "$(pwd)"/configuration/.zshrc ~/.zshrc
ln -sf "$(pwd)"/configuration/.zprofile ~/.zprofile

ln -sf "$(pwd)"/configuration/.vimrc ~/.vimrc

touch ~/.secrets
