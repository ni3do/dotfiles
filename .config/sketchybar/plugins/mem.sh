#!/usr/bin/env bash

MEM=$(top -n 1 -b | grep "Mem")
MAXMEM=$MEM | grep "Mem" | cut -c 7-14 
USEDMEM=$MEM | grep "Mem" | cut -c 25-31
$USEDPCT='echo $USEDMEM / $MAXMEM * 100 | bc'
echo " $USEDPCT%"

getPerecentage=$(TARGET_PATH="."
top -l 1 | grep -E "^CPU" | grep -Eo '[^[:space:]]+%' | head -1 | sed 's/3\(.\)$/\1/')

getMB=$(TARGET_PATH="."
top -l1 | awk '/PhysMem/ {print $2}')

perecentage=$(echo $getPerecentage)
MB=$(echo $getMB)

sketchybar --set $NAME icon="􀫦" label="$MB ($perecentage)"
