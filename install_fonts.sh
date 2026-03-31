#!/bin/zsh

wget https://github.com/IBM/plex/releases/download/%40ibm%2Fplex-mono%401.1.0/ibm-plex-mono.zip -O plex-mono.zip
unzip ./plex-mono.zip -d plex-mono
rm ./plex-mono.zip
rm -rf ~/Library/Fonts/plex-mono
mv plex-mono ~/Library/Fonts

wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/GeistMono.zip -O geist-mono.zip
unzip ./geist-mono.zip -d geist-mono
rm ./geist-mono.zip
rm -rf ~/Library/Fonts/geist-mono
mv geist-mono ~/Library/Fonts
