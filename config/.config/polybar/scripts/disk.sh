#!/bin/bash

icon=" " 

disk_info=$(df -h / | awk 'NR==2 {print $3 "/" $2}')

echo "%{F#B48EAD}$icon%{F-} $disk_info"
