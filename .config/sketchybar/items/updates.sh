### Updates Widget ###
sketchybar --add item updates right                                                \
           --set updates update_freq=1800                                          \
                       icon="􀝗"                                                   \
                       icon.font="Font Awesome 6 Free:Solid:12.4"                  \
                       icon.padding_right=7                                        \
                       icon.color=0xffc382db                                       \
                       icon.y_offset=1                                             \
                       label.y_offset=1                                            \
                       label.font="$FONT:Bold:10.6"                                \
                       label.color=0xffc382db                                      \
                       label.padding_right=8                                       \
                       background.color=0xffc382db                                 \
                       background.height=2                                         \
                       background.y_offset=-9                                      \
                       background.padding_right=8                                  \
                       script="$PLUGIN_DIR/package_monitor.sh"                     \
                       icon.padding_left=0 label.padding_right=2                   \