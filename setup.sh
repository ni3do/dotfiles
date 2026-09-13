#!/usr/bin/env bash
set -euo pipefail

# Profile: desktop (default) installs the macOS GUI stack; headless skips it.
# Override with `--mode headless` or MODE=headless.
MODE="${MODE:-desktop}"
while [ $# -gt 0 ]; do
  case "$1" in
    --mode) MODE="${2:?--mode requires an argument}"; shift 2 ;;
    --mode=*) MODE="${1#*=}"; shift ;;
    -h|--help) echo "usage: $0 [--mode desktop|headless]"; exit 0 ;;
    *) echo "unknown argument: $1" >&2; exit 1 ;;
  esac
done

case "$MODE" in
  desktop|headless) ;;
  *) echo "invalid mode: $MODE (expected desktop or headless)" >&2; exit 1 ;;
esac

# The desktop profile is macOS-only; fall back rather than fail on Linux.
if [ "$MODE" = "desktop" ] && [ "$(uname -s)" != "Darwin" ]; then
  echo "Non-macOS host detected, switching to headless mode."
  MODE=headless
fi

# macOS-only config directories, unlinked again in headless mode.
DESKTOP_ONLY=(aerospace borders ghostty kanata sketchybar)

echo "=== Dotfiles Setup (mode: $MODE) ==="

if ! command -v brew &> /dev/null; then
  echo "Homebrew not found. Please install it first: https://brew.sh"
  exit 1
fi

echo "Installing core dependencies..."
brew install stow jq curl git neovim tmux fzf zoxide starship eza bat yazi

if [ "$MODE" = "desktop" ]; then
  echo "Installing desktop tools..."
  brew tap FelixKratz/formulae
  brew install sketchybar borders kanata
  brew install --cask ghostty
  brew install --cask nikitabobko/tap/aerospace

  echo "Installing fonts..."
  brew install --cask font-jetbrains-mono-nerd-font

  # Install sketchybar-app-font
  if [ ! -f "$HOME/Library/Fonts/sketchybar-app-font.ttf" ]; then
    echo "Installing sketchybar-app-font..."
    curl -L https://github.com/kvndrsslr/sketchybar-app-font/releases/download/v2.0.28/sketchybar-app-font.ttf -o "$HOME/Library/Fonts/sketchybar-app-font.ttf"
  fi

  # Install SF Pro font (for SF Symbols in sketchybar). Probe the installed
  # file directly; fc-list needs fontconfig, which macOS does not ship.
  # Fonts are cosmetic: a CDN hiccup must not stop the dotfiles being linked.
  if ! ls "$HOME/Library/Fonts/SF-Pro"*.otf "$HOME/Library/Fonts/SF-Pro"*.ttf &> /dev/null; then
    echo "Installing SF Pro font..."
    if ! (
      set -e
      curl -L -o /tmp/SF-Pro.dmg "https://devimages-cdn.apple.com/design/resources/download/SF-Pro.dmg"
      hdiutil attach /tmp/SF-Pro.dmg -nobrowse -quiet
      pkgutil --expand "/Volumes/SFProFonts/SF Pro Fonts.pkg" /tmp/sf-pro-expanded
      cd /tmp/sf-pro-expanded/SFProFonts.pkg && cat Payload | gunzip -dc | cpio -i 2>/dev/null
      cp /tmp/sf-pro-expanded/SFProFonts.pkg/Library/Fonts/SF-Pro*.ttf \
         /tmp/sf-pro-expanded/SFProFonts.pkg/Library/Fonts/SF-Pro*.otf \
         "$HOME/Library/Fonts/" 2>/dev/null || true
      hdiutil detach /Volumes/SFProFonts -quiet 2>/dev/null || true
      rm -rf /tmp/sf-pro-expanded /tmp/SF-Pro.dmg
    ); then
      echo "WARNING: SF Pro install failed; sketchybar SF Symbols may not render." >&2
      hdiutil detach /Volumes/SFProFonts -quiet 2>/dev/null || true
      rm -rf /tmp/sf-pro-expanded /tmp/SF-Pro.dmg
    fi
  fi
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
  # Recreate as a real directory so stow cannot fold the whole tree into one
  # symlink. If it folded, $dir would point into the repo and restore_dir would
  # move the machine's other config files inside the repository.
  mkdir -p "$dir"
}

restore_dir() {
  local dir="$1" item itemname
  [ -d "${dir}.pre-stow" ] || return 0

  # The second glob catches dotfiles; without it hidden entries were dropped.
  for item in "${dir}.pre-stow"/* "${dir}.pre-stow"/.[!.]*; do
    [ -e "$item" ] || continue
    itemname=$(basename "$item")
    if [ ! -e "$dir/$itemname" ]; then
      echo "Restoring $itemname to $dir/"
      mv "$item" "$dir/"
    fi
  done

  # Anything left collides with a name this repo manages. Never delete it:
  # the previous `rmdir || rm -rf` silently destroyed pre-existing user data.
  if ! rmdir "${dir}.pre-stow" 2>/dev/null; then
    echo "WARNING: kept ${dir}.pre-stow - these names collide with dotfiles" >&2
    echo "         entries and need manual review:" >&2
    ls -A "${dir}.pre-stow" | sed 's/^/           /' >&2
  fi
}

# Restore on any exit path. Without this a stow failure leaves ~/.config and
# ~/.local stranded as *.pre-stow, because set -e aborts before the restore.
restore_all() {
  restore_dir "$HOME/.config"
  restore_dir "$HOME/.local"
}
trap restore_all EXIT

merge_dir "$HOME/.config"
merge_dir "$HOME/.local"

# Same folding hazard, higher stakes: if ~/.pi does not exist stow links the
# whole directory into the repo, and pi then writes auth.json and sessions/
# inside version control. Creating it first forces per-file links.
mkdir -p "$HOME/.pi/agent"

stow --dotfiles -t ~ .

# Stow's ignore list is only honoured for top-level package entries, so nested
# config dirs cannot be skipped during stow; unlink them afterwards instead.
# Guarded on -L so a real directory is never removed.
if [ "$MODE" = "headless" ]; then
  for d in "${DESKTOP_ONLY[@]}"; do
    if [ -L "$HOME/.config/$d" ]; then
      echo "Skipping macOS-only config: $d"
      rm "$HOME/.config/$d"
    fi
  done
fi

restore_all
trap - EXIT

# Check if the directory is nonexistent or empty, then create it and download antigen
if [ ! -r "$HOME/.config/antigen/antigen.zsh" ]; then
  mkdir -p "$HOME/.config/antigen"
  curl --fail --location git.io/antigen > "$HOME/.config/antigen/antigen.zsh"
fi

# Check if the directory is nonexistent or empty, then clone tpm
if [ ! -d "$HOME/.tmux/plugins/tpm" ] || [ -z "$(ls -A "$HOME/.tmux/plugins/tpm")" ]; then
  git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
fi

if [ "$MODE" = "desktop" ]; then
  echo "Starting sketchybar..."
  brew services start sketchybar || true
fi

echo "Done."
