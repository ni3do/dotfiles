#!/bin/bash

bar=(
  position=top
  height=40
  margin=8
  y_offset=4
  corner_radius=12
  blur_radius=30
  color="$BAR_COLOR"
  border_width=0
  shadow=on
  sticky=on
  padding_left=12
  padding_right=12
)

sketchybar --bar "${bar[@]}"
