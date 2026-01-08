#!/bin/zsh
ln -sf "$(pwd)"/configuration/.tflint.hcl ~/.tflint.hcl
tflint --init

mkdir -p ~/.config/zed/
ln -sf "$(pwd)"/configuration/zed/settings.json ~/.config/zed/settings.json

touch ~/.terraformrc
CACHE_PATH="$HOME/.terraform.d/plugin-cache"
echo "plugin_cache_dir   = \"$CACHE_PATH\"" > ~/.terraformrc

mkdir -p $CACHE_PATH
