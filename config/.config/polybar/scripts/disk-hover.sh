#!/bin/bash

ACTION=$1
WINDOW_ID_FILE="/tmp/disk_hover_window"

# Check if the window is already running
if [[ "$ACTION" == "toggle" ]]; then
    if [[ -f $WINDOW_ID_FILE ]]; then
        # If the window is running, kill it (left-click anywhere to close)
        WINDOW_PID=$(cat $WINDOW_ID_FILE)
        wmctrl -ic $WINDOW_PID
        rm $WINDOW_ID_FILE
    else
        # Show detailed disk usage in yad
        eval "$(xdotool getmouselocation --shell)"  # Get mouse position

        # Display disk usage (change the command below as needed)
        yad --title="Disk Information" --text "$(df -h)" --posx=$X --posy=$((Y + 20)) \
            --no-buttons --undecorated --fixed --skip-taskbar --close-on-unfocus --raise &

        # Get the window ID of the `yad` window
        WINDOW_ID=$(xdotool getactivewindow)
        echo $WINDOW_ID > $WINDOW_ID_FILE
    fi
fi
