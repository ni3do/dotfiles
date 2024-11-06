#!/bin/zsh

# Copying and checking out configuration files
echo "Planting Configuration Files..."
[ ! -d "$HOME/dotfiles" ] && git clone --bare git@github.com:ni3do/dotfiles.git $HOME/dotfiles
git --git-dir=$HOME/dotfiles --work-tree=$HOME checkout master
git --git-dir=$HOME/dotfiles --work-tree=$HOME config --local status.showUntrackedFiles no

# Copying configuration files
cp -r $HOME/dotfiles/config/* $HOME/.config/
cp $HOME/dotfiles/zshrc $HOME/.zshrc
