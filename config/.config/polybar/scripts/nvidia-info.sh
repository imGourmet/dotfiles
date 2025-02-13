#!/bin/bash

# Set the icon (you can use any icon from your font set)
icon1=" "
icon2=" "
# Get the GPU temperature
temp=$(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits)

# Get GPU utilization (stress)
util=$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits)

# Color temperature and utilization
if [ "$temp" -ge 80 ]; then
    temp_color="%{F#FF0000}"  # Red for high temp
elif [ "$temp" -ge 60 ]; then
    temp_color="%{F#FFCC00}"  # Yellow for moderate temp
else
    temp_color="%{F#88C0D0}"  # Blue for cool temp
fi

# Return formatted output with color and icon
echo "%{F#A3BE8C}$icon1%{F-}$util%  $temp_color$icon2%{F-}$temp°C"
