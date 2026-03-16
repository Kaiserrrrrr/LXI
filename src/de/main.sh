#!/bin/bash

sudo -v; clear

URL="https://raw.githubusercontent.com/kaiserrrrrr/aqtive/main/src/de"

PKG=$(curl -s $URL/$DE/install.txt)
sudo pacman -Syu --noconfirm && sudo pacman $PKG --noconfirm && sudo pacman -Scc --noconfirm
