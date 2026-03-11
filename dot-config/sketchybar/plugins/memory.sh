#!/bin/bash

# Get memory pressure percentage
MEMORY=$(memory_pressure | grep "System-wide memory free percentage:" | awk '{print 100-$5}' | tr -d '%')

if [ -z "$MEMORY" ]; then
  # Fallback: calculate from vm_stat
  PAGES_FREE=$(vm_stat | grep "Pages free" | awk '{print $3}' | tr -d '.')
  PAGES_INACTIVE=$(vm_stat | grep "Pages inactive" | awk '{print $3}' | tr -d '.')
  PAGES_SPECULATIVE=$(vm_stat | grep "Pages speculative" | awk '{print $3}' | tr -d '.')
  TOTAL_MEM=$(sysctl -n hw.memsize)

  PAGE_SIZE=16384
  FREE_MEM=$(( (PAGES_FREE + PAGES_INACTIVE + PAGES_SPECULATIVE) * PAGE_SIZE ))
  MEMORY=$(( 100 - (FREE_MEM * 100 / TOTAL_MEM) ))
fi

sketchybar --set "$NAME" label="${MEMORY}%"
