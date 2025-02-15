#!/bin/bash

green="%{F#A3BE8C}"  
red="%{F#BF616A}"    
reset="%{F-}"

vpn_ip=$(curl -s --max-time 2 ifconfig.me)

if ip a | grep -q "tun0"; then
    echo "${green}${reset} $vpn_ip"
else
    echo "${red}${reset} No VPN"
fi
