#!/bin/bash

# Try to get info from event first
STATE="$(echo "$INFO" | jq -r '.["Player State"]' 2>/dev/null)"

# If no event info, query Spotify directly
if [ -z "$STATE" ] || [ "$STATE" = "null" ]; then
  if pgrep -x "Spotify" > /dev/null; then
    STATE=$(osascript -e 'tell application "Spotify" to player state as string' 2>/dev/null)
    TRACK=$(osascript -e 'tell application "Spotify" to name of current track as string' 2>/dev/null)
    ARTIST=$(osascript -e 'tell application "Spotify" to artist of current track as string' 2>/dev/null)
  fi
else
  TRACK="$(echo "$INFO" | jq -r '.Name')"
  ARTIST="$(echo "$INFO" | jq -r '.Artist')"
fi

if [ "$STATE" = "Playing" ] || [ "$STATE" = "playing" ]; then
  if [ -n "$TRACK" ] && [ "$TRACK" != "null" ]; then
    sketchybar --set "$NAME" icon=􀑪 label="${TRACK} - ${ARTIST}" drawing=on
  fi
elif [ "$STATE" = "Paused" ] || [ "$STATE" = "paused" ]; then
  sketchybar --set "$NAME" icon=􀊆 label="${TRACK} - ${ARTIST}" drawing=on
else
  sketchybar --set "$NAME" drawing=off
fi
