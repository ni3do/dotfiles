#!/bin/bash

# Fetch weather from wttr.in (no API key needed)
WEATHER=$(curl -s "wttr.in/?format=%c%t" 2>/dev/null | tr -d '+')

if [ -n "$WEATHER" ] && [ "$WEATHER" != "Unknown" ]; then
  # Extract just the temperature part
  TEMP=$(echo "$WEATHER" | grep -oE '[-]?[0-9]+°C')
  ICON=$(echo "$WEATHER" | sed 's/[0-9°C-]//g' | tr -d ' ')

  if [ -n "$TEMP" ]; then
    sketchybar --set "$NAME" label="$TEMP" icon="$ICON"
  else
    sketchybar --set "$NAME" label="$WEATHER"
  fi
else
  sketchybar --set "$NAME" label="--"
fi
