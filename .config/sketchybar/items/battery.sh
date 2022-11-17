#!/usr/bin/env sh

sketchybar -m --add item battery right \
              --set battery update_freq=120 \
                    script="$PLUGIN_DIR/power.sh" \
                    icon=􀛨 \
                    icon.color=$TEXT \
                    label.color=$TEXT \
                    background.color=$SURFACE2 \
                    background.height=24 \
                    background.corner_radius=4 \
                    icon.padding_left=4 \
                    label.padding_right=4 