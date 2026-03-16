#!/bin/bash

bar=(
  position=top
  height=32
  margin=8
  y_offset=4
  corner_radius=10
  blur_radius=30
  color="$BAR_COLOR"
  border_width=0
  shadow=on
  sticky=on
  padding_left=10
  padding_right=10
)

sketchybar --bar "${bar[@]}"
