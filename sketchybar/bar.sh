#!/bin/bash

bar=(
  position=top
  height=38
  blur_radius=30
  color="$BAR_COLOR"
)

sketchybar --bar "${bar[@]}"
