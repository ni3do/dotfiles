#!/bin/bash

sketchybar --add item media center \
  --set media \
  icon=􀑪 \
  icon.font=".SF Symbols Fallback:Regular:16.0" \
  icon.color="$GREEN" \
  label.max_chars=40 \
  label.color="$SUBTEXT" \
  scroll_texts=on \
  background.drawing=on \
  background.color="$SURFACE1" \
  update_freq=5 \
  script="$PLUGIN_DIR/media.sh" \
  --subscribe media media_change
