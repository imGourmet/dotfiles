#!/bin/bash

icon1=" "
icon2=" "

temp=$(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits)

util=$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits)

if [ "$temp" -ge 80 ]; then
    temp_color="%{F#FF0000}"  # Red for high temp
elif [ "$temp" -ge 65 ]; then
    temp_color="%{F#FFCC00}"  # Yellow for moderate temp
else
    temp_color="%{F#88C0D0}"  # Blue for cool temp
fi

echo "%{F#A3BE8C}$icon1%{F-}$util%  $temp_color$icon2%{F-}$temp°C"
