### Battery Widget ###
sketchybar --add item battery right                                                \
           --set battery update_freq=2                                             \
                       icon.font="Font Awesome 6 Free:Solid:12.4"                  \
                       icon.padding_right=3                                        \
                       icon.color=0xffcf8f5f                                       \
                       icon.y_offset=2                                             \
                       label.y_offset=1                                            \
                       label.font="$FONT:Bold:10.4"                                \
                       label.color=0xffcf8f5f                                      \
                       label.padding_right=8                                       \
                       background.color=0xffcf8f5f                                 \
                       background.height=2                                         \
                       background.y_offset=-9                                      \
                       background.padding_right=8                                  \
                       script="$PLUGIN_DIR/battery.sh"                             \
                       icon.padding_left=0 label.padding_right=0                   \