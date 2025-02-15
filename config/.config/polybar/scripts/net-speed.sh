#!/bin/bash

INTERFACE="enp42s0"

RX_FILE="/sys/class/net/$INTERFACE/statistics/rx_bytes"
TX_FILE="/sys/class/net/$INTERFACE/statistics/tx_bytes"

rx1=$(cat $RX_FILE)
tx1=$(cat $TX_FILE)

sleep 1

rx2=$(cat $RX_FILE)
tx2=$(cat $TX_FILE)

rx_speed=$(( rx_speed / 1024 ))  # MB/s
tx_speed=$(( tx_speed / 1024 ))  # MB/s

latency=$(ping -c 1 8.8.8.8 | grep 'time=' | awk -F 'time=' '{ print $2 }' | awk '{ print $1 }')

echo "%{F#B48EAD}%{F-} ${rx_speed} MB/s  %{F#A3BE8C}%{F-} ${tx_speed} MB/s  %{F#D08770}󰀂%{F-} ${latency} ms"
