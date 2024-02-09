#!/bin/zsh

wget https://github.com/zed-industries/zed-fonts/releases/download/1.2.0/zed-mono-1.2.0.zip -O zed-mono.zip
unzip ./zed-mono.zip -d zed-mono
rm ./zed-mono.zip
mv -R zed-mono ~/Library/Fonts
