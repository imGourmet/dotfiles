#!/bin/bash

raw_temp=$(sensors | grep 'Tctl')

temperature=$(echo "$raw_temp" | awk '{print $2}' | sed 's/[+°C]//g')


if [ -z "$temperature" ]; then
    echo "Error: Could not get temperature."
    exit 1
fi

if (( $(echo "$temperature < 50" | bc -l) )); then
    color="#88C0D0"  # Cyan -50°C
elif (( $(echo "$temperature >= 50 && $temperature <= 60" | bc -l) )); then
    color="#FFCC00"  # Yellow {50°C,60°C}
else
    color="#BF616A"  # Red +60°C
fi

echo "%{F$color} %{F-}$temperature°C"
