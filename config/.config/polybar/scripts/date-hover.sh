#!/bin/bash

ACTION=$1

if [[ "$ACTION" == "toggle" ]]; then
    pkill -f "gnome-calendar" && exit 0  # Close if running

    export GTK_THEME="Nordic:dark"
    gsettings set org.gnome.desktop.interface gtk-theme "Nordic"

    gnome-calendar &

    sleep 1
    WINDOW_ID=$(xdotool search --onlyvisible --class "gnome-calendar" | head -1) && \
    bspc node "$WINDOW_ID" -t floating
fi
