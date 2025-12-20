#!/usr/bin/env bash
set -euo pipefail

echo "Linking dotfiles..."
stow --dotfiles -t ~ .

# Check if the directory is nonexistent or empty, then create it and download antigen
if [ ! -r "$HOME/.config/antigen/antigen.zsh" ]; then
  mkdir -p "$HOME/.config/antigen"
  curl --fail --location git.io/antigen > "$HOME/.config/antigen/antigen.zsh"
fi

# Check if the directory is nonexistent or empty, then clone tpm
if [ ! -d "$HOME/.tmux/plugins/tpm" ] || [ -z "$(ls -A "$HOME/.tmux/plugins/tpm")" ]; then
  git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
fi
