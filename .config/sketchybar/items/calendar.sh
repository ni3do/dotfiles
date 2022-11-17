#!/usr/bin/env sh

sketchybar --add item     calendar right                         \
           --set calendar icon=cal                               \
                          icon.padding_right=4                  \
                          label.padding_left=0                 \
                          label.color=$TEXT                    \
                          background.padding_left=0             \
                          align=center                          \
                          background.color=$SURFACE2  \
                          background.height=24         \
                          background.corner_radius=4\
                          click_script="$PLUGIN_DIR/zen.sh"
