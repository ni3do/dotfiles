#!/bin/bash

sketchybar --add item wifi right \
  --set wifi \
  icon=􀙇 \
  icon.font=".SF Symbols Fallback:Regular:16.0" \
  label.drawing=off \
  background.drawing=on \
  script="$PLUGIN_DIR/wifi.sh" \
  update_freq=30 \
  --subscribe wifi wifi_change
