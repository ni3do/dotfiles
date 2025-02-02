#! /bin/bash

# Fetch stock data using Perl and jq
read -r previous_close last_trade_price < <(
  curl -k -L -s --compressed "https://robinhood.com/us/en/stocks/VTI/" |
    perl -ne 'print "$1\n" if /"quote":\K(\{.*?\})/' |
    jq -r '.adjusted_previous_close, .last_trade_price'
)

# Ensure values are numerical
# if [[ -z "$previous_close" || -z "$last_trade_price" || ! "$previous_close" =~ ^[0-9]+(\.[0-9]+)?$ || ! "$last_trade_price" =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
#   echo "Error: Could not retrieve valid stock data."
#   exit 1
# fi

echo "$previous_close"
echo "$last_trade_price"
# Calculate percentage change
change=$(echo "scale=2; (($last_trade_price - $previous_close) / $previous_close) * 100" | bc)

echo "$change%"

# Determine icon color for sketchybar
if (($(echo "$change >= 0" | bc -l))); then
  sketchybar --set "$NAME" icon.color=0xff00ff00 # Green color
else
  sketchybar --set "$NAME" icon.color=0xffff0000 # Red color
fi

# Update sketchybar label
sketchybar --set "$NAME" label="$(printf "%.2f%%" "$change")"
