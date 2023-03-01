### ssd Widget ###
sketchybar --add item  ssd right                                                   \
           --set ssd   update_freq=10                                              \
                       icon.font="Font Awesome 6 Free:Solid:13.3"                  \
                       icon.padding_right=4                                        \
                       icon.color=0xffa7abe0                                       \
                       icon.y_offset=1                                             \
                       label.y_offset=1                                            \
                       label.font="$FONT:Bold:10.6"                                \
                       label.color=0xffa7abe0                                      \
                       label.padding_right=8                                       \
                       background.color=0xffa7abe0                                 \
                       background.height=2                                         \
                       background.y_offset=-9                                      \
                       background.padding_right=8                                  \
                       script="$PLUGIN_DIR/disk.sh"                                \
                       icon.padding_left=0 label.padding_right=2                   \