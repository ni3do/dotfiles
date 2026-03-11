#!/bin/bash

sketchybar --add item memory right \
  --set memory \
  icon=􀫦 \
  icon.font=".SF Symbols Fallback:Regular:16.0" \
  icon.color="$MAGENTA" \
  update_freq=5 \
  background.drawing=on \
  script="$PLUGIN_DIR/memory.sh"
