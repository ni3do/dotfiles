#!/bin/bash

source "$CONFIG_DIR/colors.sh"

# Check for any active network connection
WIFI_SSID=$(networksetup -getairportnetwork en0 2>/dev/null | sed 's/Current Wi-Fi Network: //')

if [ -n "$WIFI_SSID" ] && [ "$WIFI_SSID" != "You are not associated with an AirPort network." ]; then
  # WiFi connected
  sketchybar --set "$NAME" icon=􀙇 icon.color="$TEXT"
elif ifconfig en0 2>/dev/null | grep -q "status: active"; then
  # Ethernet connected
  sketchybar --set "$NAME" icon=􁠺 icon.color="$TEXT"
else
  # No connection
  sketchybar --set "$NAME" icon=􀙈 icon.color="$RED"
fi
