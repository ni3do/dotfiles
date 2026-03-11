#!/bin/bash

sketchybar --add item calendar right \
  --set calendar \
  icon=􀧞 \
  icon.font=".SF Symbols Fallback:Regular:16.0" \
  icon.color="$ORANGE" \
  background.drawing=on \
  update_freq=30 \
  script="$PLUGIN_DIR/calendar.sh"
