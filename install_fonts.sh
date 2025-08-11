#!/bin/zsh

wget https://github.com/zed-industries/zed-fonts/releases/download/1.2.0/zed-mono-1.2.0.zip -O zed-mono.zip
unzip ./zed-mono.zip -d zed-mono
rm ./zed-mono.zip
rm -rf ~/Library/Fonts/zed-mono
mv zed-mono ~/Library/Fonts

wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/GeistMono.zip -O geist-mono.zip
unzip ./geist-mono.zip -d geist-mono
rm ./geist-mono.zip
rm -rf ~/Library/Fonts/geist-mono
mv geist-mono ~/Library/Fonts
