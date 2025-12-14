#!/usr/bin/env bash
set -euo pipefail

MODE="${MODE:-desktop}"
STOW_IGNORE=()

usage() {
  cat <<'EOF'
Usage: ./setup.sh [--mode <desktop|headless>]

Modes:
  desktop  (default) Link every config, including macOS-only tools.
  headless Skip desktop-only configs (aerospace, borders, ghostty, kanata, karabiner, sketchybar).

You can also set MODE=headless in the environment, e.g. MODE=headless ./setup.sh
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --mode)
      MODE="${2:-}"
      [[ -n "$MODE" ]] || { echo "Missing argument for --mode" >&2; usage; exit 1; }
      shift 2
      ;;
    --mode=*)
      MODE="${1#*=}"
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      usage
      exit 1
      ;;
  esac
done

case "$MODE" in
  desktop)
    ;;
  headless)
    STOW_IGNORE+=(
      "--ignore=^(dot-config/(aerospace|borders|ghostty|kanata|karabiner|sketchybar))($|/)"
    )
    ;;
  *)
    echo "Unsupported mode: $MODE" >&2
    usage
    exit 1
    ;;
esac

echo "Linking dotfiles in \"$MODE\" mode..."
if [[ ${#STOW_IGNORE[@]} -gt 0 ]]; then
  stow --dotfiles -t ~ "${STOW_IGNORE[@]}" .
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
