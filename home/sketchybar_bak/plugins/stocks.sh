#!/usr/bin/env zsh

array=(
    $(
        perl -e '
            $json = `curl -k -L -s --compressed https://robinhood.com/us/en/stocks/VTI/`;
            if ($json =~ /"quote":\K(\{.*?\})/) {
                print "$1";
            }
        ' |
        jq -r '.adjusted_previous_close,.last_trade_price'
    )
)

# Ensure we got two values
if [[ ${#array[@]} -ne 2 ]]; then
    echo "Error: Failed to fetch stock prices."
    exit 1
fi

previous_close=${array[0]}
last_trade_price=${array[1]}

# Calculate daily return ratio
if [[ -n "$previous_close" && -n "$last_trade_price" && "$previous_close" != "null" && "$last_trade_price" != "null" ]]; then
    daily_return_ratio=$(awk -v prev="$previous_close" -v last="$last_trade_price" 'BEGIN { printf "%.6f", (last - prev) / prev }')
    echo "Daily Return Ratio: $daily_return_ratio"
else
    echo "Error: Invalid stock data received."
    exit 1
fi

if [[ $change -ge 0 ]]; then 
    sketchybar --set $NAME icon.color=0xff{{ .dracula.hex.green }}
elif [[ $change -lt 0 ]]; then
    sketchybar --set $NAME icon.color=0xff{{ .dracula.hex.red }}
fi

sketchybar --set $NAME label=$(printf "%.*f\n" 2 "$change")


