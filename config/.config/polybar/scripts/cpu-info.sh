#!/bin/bash

icon1=" "  # CPU icon
icon2=" "  # Temperature icon

CPU_USAGE=$(mpstat 1 1 | awk '/Average/ {print int(100 - $NF)}')

CPU_TEMP=$(sensors | awk '/Tctl/ {print int($2)}' | tr -d '+')

if [ "${CPU_TEMP%.*}" -ge 80 ]; then
    TEMP_COLOR="%{F#FF0000}"  # Red for high temp
elif [ "${CPU_TEMP%.*}" -ge 60 ]; then
    TEMP_COLOR="%{F#FFCC00}"  # Yellow for moderate temp
else
    TEMP_COLOR="%{F#88C0D0}"  # Blue for cool temp
fi

echo "%{F#D08770}$icon1%{F-}$CPU_USAGE%  $TEMP_COLOR$icon2%{F-}$CPU_TEMP°C"
