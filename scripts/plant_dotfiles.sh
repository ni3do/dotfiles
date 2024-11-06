#!/bin/zsh

# Copying and checking out configuration files
echo "Planting Configuration Files..."
[ ! -d "$HOME/dotfiles" ] && git clone -b master git@github.com:ni3do/dotfiles.git $HOME/dotfiles

# Copying configuration files
cp -r $HOME/dotfiles/config/* $HOME/.config/
cp $HOME/dotfiles/zshrc $HOME/.zshrc
