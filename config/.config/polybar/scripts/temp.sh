#!/bin/bash

# Fetch CPU temperature (Tctl)
raw_temp=$(sensors | grep 'Tctl')

# Extract the actual temperature value
temperature=$(echo "$raw_temp" | awk '{print $2}' | sed 's/[+°C]//g')


# Check if the temperature variable is set
if [ -z "$temperature" ]; then
    echo "Error: Could not get temperature."
    exit 1
fi

# Assign colors based on temperature using `bc` for floating-point comparisons
if (( $(echo "$temperature < 50" | bc -l) )); then
    color="#88C0D0"  # Cyan for temperatures below 50°C
elif (( $(echo "$temperature >= 50 && $temperature <= 60" | bc -l) )); then
    color="#FFCC00"  # Yellow for temperatures between 50°C and 60°C
else
    color="#BF616A"  # Red for temperatures above 60°C
fi

# Output the temperature with the assigned color and icon
echo "%{F$color} %{F-}$temperature°C"
