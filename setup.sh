#!/usr/bin/env bash
set -euo pipefail

echo "Linking dotfiles..."

# Workaround for stow 2.3.1 bug with --dotfiles when ~/.config exists
# Temporarily move ~/.config if it exists, stow, then restore non-conflicting items
if [ -d "$HOME/.config" ] && [ ! -L "$HOME/.config" ]; then
  echo "Found existing ~/.config directory, handling merge..."
  mv "$HOME/.config" "$HOME/.config.pre-stow"
  stow --dotfiles -t ~ .

  # Restore non-conflicting items from old .config
  if [ -d "$HOME/.config.pre-stow" ]; then
    for item in "$HOME/.config.pre-stow"/*; do
      if [ -e "$item" ]; then
        itemname=$(basename "$item")
        if [ ! -e "$HOME/.config/$itemname" ]; then
          echo "Restoring $itemname to ~/.config/"
          mv "$item" "$HOME/.config/"
        fi
      fi
    done
    rmdir "$HOME/.config.pre-stow" 2>/dev/null || rm -rf "$HOME/.config.pre-stow"
  fi
else
  stow --dotfiles -t ~ .
fi

# Check if the directory is nonexistent or empty, then create it and download antigen
if [ ! -r "$HOME/.config/antigen/antigen.zsh" ]; then
  mkdir -p "$HOME/.config/antigen"
  curl --fail --location git.io/antigen > "$HOME/.config/antigen/antigen.zsh"
fi

# Check if the directory is nonexistent or empty, then clone tpm
if [ ! -d "$HOME/.tmux/plugins/tpm" ] || [ -z "$(ls -A "$HOME/.tmux/plugins/tpm")" ]; then
  git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
fi
