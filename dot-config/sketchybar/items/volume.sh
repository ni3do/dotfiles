#!/bin/bash

sketchybar --add item volume right \
  --set volume \
  icon.font=".SF Symbols Fallback:Regular:16.0" \
  icon.color="$BLUE" \
  background.drawing=on \
  script="$PLUGIN_DIR/volume.sh" \
  --subscribe volume volume_change display_volume_change
