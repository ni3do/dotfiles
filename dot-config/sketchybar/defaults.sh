#!/bin/bash

default=(
  padding_left=4
  padding_right=4
  icon.font="${FONT}:Bold:15.0"
  label.font="${FONT}:Medium:13.0"
  icon.color="$TEXT"
  label.color="$TEXT"
  icon.padding_left=8
  icon.padding_right=4
  label.padding_left=4
  label.padding_right=8
  background.color="$ITEM_BG_COLOR"
  background.corner_radius=8
  background.height=28
  background.drawing=on
  background.border_width=0
)

sketchybar --default "${default[@]}"

sketchybar --add event aerospace_workspace_change
sketchybar --add event aerospace_mode_change
sketchybar --add event display_volume_change
sketchybar --add event media_change "com.spotify.client.PlaybackStateChanged"
