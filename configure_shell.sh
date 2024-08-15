#!/bin/zsh

ln -sf "$(pwd)"/configuration/com.googlecode.iterm2.plist ~/com.googlecode.iterm2.plist

# see https://ohmyz.sh/#install
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

ln -sf "$(pwd)"/configuration/starship.toml ~/.starship.toml

ln -sf "$(pwd)"/configuration/.zshrc ~/.zshrc
ln -sf "$(pwd)"/configuration/.zprofile ~/.zprofile

ln -sf "$(pwd)"/configuration/.vimrc ~/.vimrc
