#!/bin/zsh

ln -sf "$(pwd)"/configuration/ghostty-configuration ~/Library/Application\ Support/com.mitchellh.ghostty/config

# see https://ohmyz.sh/#install
# RUNZSH and CHSH keep the installer non-interactive so make does not block.
# KEEP_ZSHRC stops it replacing the .zshrc symlinked below.
if [ ! -d ~/.oh-my-zsh ]; then
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

ln -sf "$(pwd)"/configuration/starship.toml ~/.starship.toml

ln -sf "$(pwd)"/configuration/.zshenv ~/.zshenv
ln -sf "$(pwd)"/configuration/.zshrc ~/.zshrc
ln -sf "$(pwd)"/configuration/.zprofile ~/.zprofile

ln -sf "$(pwd)"/configuration/.vimrc ~/.vimrc
