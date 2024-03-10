#!/bin/zsh

ln -sf "$(pwd)"/configuration/com.googlecode.iterm2.plist ~/com.googlecode.iterm2.plist

# see https://ohmyz.sh/#install
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

ln -sf "$(pwd)"/configuration/starship.toml ~/.starship.toml

ln -sf "$(pwd)"/configuration/.zshrc ~/.zshrc

ln -sf "$(pwd)"/configuration/.tflint.hcl ~/.tflint.hcl
tflint --init

ln -sf "$(pwd)"/configuration/.vimrc ~/.vimrc

ln -sf "$(pwd)"/configuration/zed/settings.json ~/.config/zed/settings.json

touch ~/.terraformrc
CACHE_PATH="$HOME/.terraform.d/plugin-cache"
echo "plugin_cache_dir   = \"$CACHE_PATH\"" >> ~/.terraformrc

mkdir -p $CACHE_PATH
