#!/usr/bin/env bash

# Check if the directory is nonexistent or empty, then create it and download antigen
if [ ! -r "$HOME/.config/antigen/antigen.zsh" ]; then
  mkdir -p ~/.config/antigen
  curl -L git.io/antigen > ~/.config/antigen/antigen.zsh
fi

cp zshenv ~/.zshenv

stow .
