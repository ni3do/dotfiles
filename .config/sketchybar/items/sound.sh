#!/usr/bin/env sh

sketchybar  -m --add item sound right     \
                    --set sound                \
                    script="$PLUGIN_DIR/sound.sh" \
                    icon=􀊡                  \
                    icon.color=$TEXT \
                    label.color=$TEXT \
                    background.padding_right=0    \
                    background.color=$SURFACE2 \
                    background.height=24 \
                    background.corner_radius=4 \
                    update_freq=5