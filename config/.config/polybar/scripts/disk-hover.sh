#!/bin/bash

ACTION=$1
WINDOW_ID_FILE="/tmp/disk_hover_window"

if [[ "$ACTION" == "toggle" ]]; then
    if [[ -f $WINDOW_ID_FILE ]]; then
        WINDOW_PID=$(cat $WINDOW_ID_FILE)
        wmctrl -ic $WINDOW_PID
        rm $WINDOW_ID_FILE
    else
        eval "$(xdotool getmouselocation --shell)"

        yad --title="Disk Information" --text "$(df -h)" --posx=$X --posy=$((Y + 20)) \
            --no-buttons --undecorated --fixed --skip-taskbar --close-on-unfocus --raise &

        WINDOW_ID=$(xdotool getactivewindow)
        echo $WINDOW_ID > $WINDOW_ID_FILE
    fi
fi
