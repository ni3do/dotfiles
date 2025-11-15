#!/usr/bin/env bash
set -euo pipefail

session=kanata
cmd="sudo /opt/homebrew/bin/kanata -c ~/.config/kanata/personal.kbd"

tmux kill-session -t "$session" 2>/dev/null || true
tmux new-session -d -s "$session" "$cmd"
