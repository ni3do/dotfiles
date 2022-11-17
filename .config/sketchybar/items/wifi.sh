#!/usr/bin/env sh

sketchybar --add item wifi right                         \
           --set wifi    script="$PLUGIN_DIR/wifi.sh"    \
                    icon.color=$TEXT \
                    label.color=$TEXT \
                    background.padding_right=0    \
                    background.color=$SURFACE2 \
                    background.height=24 \
                    background.corner_radius=4 \
                    update_freq=5