#!/usr/bin/env bash
set -euo pipefail

echo "Linking dotfiles..."

# If ~/.config is a symlink pointing into the stow tree, remove it so stow can manage it properly
if [ -L "$HOME/.config" ]; then
  echo "Removing old ~/.config symlink..."
  rm "$HOME/.config"
fi

# Helper: temporarily move a dir, stow, then restore non-conflicting items
merge_dir() {
  local dir="$1"
  if [ -d "$dir" ] && [ ! -L "$dir" ]; then
    echo "Found existing $dir, handling merge..."
    mv "$dir" "${dir}.pre-stow"
  fi
}

restore_dir() {
  local dir="$1"
  if [ -d "${dir}.pre-stow" ]; then
    for item in "${dir}.pre-stow"/*; do
      [ -e "$item" ] || continue
      itemname=$(basename "$item")
      if [ ! -e "$dir/$itemname" ]; then
        echo "Restoring $itemname to $dir/"
        mv "$item" "$dir/"
      fi
    done
    rmdir "${dir}.pre-stow" 2>/dev/null || rm -rf "${dir}.pre-stow"
  fi
}

merge_dir "$HOME/.config"
merge_dir "$HOME/.local"

stow --dotfiles -t ~ .

restore_dir "$HOME/.config"
restore_dir "$HOME/.local"

# Check if the directory is nonexistent or empty, then create it and download antigen
if [ ! -r "$HOME/.config/antigen/antigen.zsh" ]; then
  mkdir -p "$HOME/.config/antigen"
  curl --fail --location git.io/antigen > "$HOME/.config/antigen/antigen.zsh"
fi

# Check if the directory is nonexistent or empty, then clone tpm
if [ ! -d "$HOME/.tmux/plugins/tpm" ] || [ -z "$(ls -A "$HOME/.tmux/plugins/tpm")" ]; then
  git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
fi
