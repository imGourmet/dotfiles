#!/bin/bash
yellow_color="%{F#EBCB8B}"  
reset_color="%{F-}"

ip_address=$(ip addr show | awk '/inet / && !/127.0.0.1/ {print $2; exit}')
echo "${yellow_color}󰩟${reset_color} $ip_address"
