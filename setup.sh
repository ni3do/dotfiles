#!/usr/bin/env bash
set -euo pipefail

echo "=== Dotfiles Setup ==="

# Check for Homebrew
if ! command -v brew &> /dev/null; then
  echo "Homebrew not found. Please install it first: https://brew.sh"
  exit 1
fi

echo "Installing dependencies..."
brew install stow jq curl

echo "Installing fonts..."
brew install --cask font-jetbrains-mono-nerd-font

# Install sketchybar-app-font
if [ ! -f "$HOME/Library/Fonts/sketchybar-app-font.ttf" ]; then
  echo "Installing sketchybar-app-font..."
  curl -L https://github.com/kvndrsslr/sketchybar-app-font/releases/download/v2.0.28/sketchybar-app-font.ttf -o "$HOME/Library/Fonts/sketchybar-app-font.ttf"
fi

# Install SF Pro font (for SF Symbols in sketchybar)
if ! fc-list | grep -q "SF Pro"; then
  echo "Installing SF Pro font..."
  curl -L -o /tmp/SF-Pro.dmg "https://devimages-cdn.apple.com/design/resources/download/SF-Pro.dmg"
  hdiutil attach /tmp/SF-Pro.dmg -nobrowse -quiet
  pkgutil --expand "/Volumes/SFProFonts/SF Pro Fonts.pkg" /tmp/sf-pro-expanded
  cd /tmp/sf-pro-expanded/SFProFonts.pkg && cat Payload | gunzip -dc | cpio -i 2>/dev/null
  cp /tmp/sf-pro-expanded/SFProFonts.pkg/Library/Fonts/SF-Pro*.ttf /tmp/sf-pro-expanded/SFProFonts.pkg/Library/Fonts/SF-Pro*.otf "$HOME/Library/Fonts/" 2>/dev/null || true
  hdiutil detach /Volumes/SFProFonts -quiet 2>/dev/null || true
  rm -rf /tmp/sf-pro-expanded /tmp/SF-Pro.dmg
  cd - > /dev/null
fi

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
