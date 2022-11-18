#!/usr/bin/env sh

MEMORY=$(memory_pressure | grep "System-wide memory free percentage:"  | awk '{ printf("%2.0f\n", 100-$5"%") }')

sketchybar -m --set mem label="${MEMORY}%"