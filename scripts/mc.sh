#!/bin/sh
mc
mkdir ~/.local/share/mc/skins -p && cd ~/.local/share/mc/skins && wget https://raw.githubusercontent.com/soko1/dotfiles/refs/heads/master/.local/share/mc/skins/electricblue256.ini && sed -i s/default/electricblue256/ ~/.config/mc/ini
