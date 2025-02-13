#!/bin/bash

ACTION=$1
WINDOW_ID_FILE="/tmp/gpu_hover_window"

# Check if the window is already running
if [[ "$ACTION" == "toggle" ]]; then
    if [[ -f $WINDOW_ID_FILE ]]; then
        # If the window is running, kill it (left-click anywhere to close)
        WINDOW_PID=$(cat $WINDOW_ID_FILE)

        # Try using wmctrl to kill the window by its ID
        wmctrl -ic $WINDOW_PID

        rm $WINDOW_ID_FILE
    else
        # If the window is not running, show it
        eval "$(xdotool getmouselocation --shell)"  # Get mouse position

        # Show floating window with nvidia-smi output (no timeout)
        yad --text "$(nvidia-smi)" --posx=$X --posy=$((Y + 20)) \
            --no-buttons --undecorated --fixed --skip-taskbar \
            --fontname="Hack Nerd Font 10" --close-on-unfocus --raise &

        # Get the window ID of the yad window
        WINDOW_ID=$(xdotool getactivewindow)

        # Store the window ID
        echo $WINDOW_ID > $WINDOW_ID_FILE
    fi
fi 
