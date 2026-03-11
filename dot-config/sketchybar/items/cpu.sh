#!/bin/bash

sketchybar --add item cpu right \
  --set cpu \
  update_freq=2 \
  icon=􀧓 \
  icon.font=".SF Symbols Fallback:Regular:16.0" \
  icon.color="$CYAN" \
  background.drawing=on \
  script="$PLUGIN_DIR/cpu.sh"
