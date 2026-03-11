#!/bin/bash

sketchybar --add item weather right \
  --set weather \
  icon=􀇔 \
  icon.font=".SF Symbols Fallback:Regular:16.0" \
  icon.color="$YELLOW" \
  update_freq=1800 \
  background.drawing=on \
  script="$PLUGIN_DIR/weather.sh"
