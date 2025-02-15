#!/bin/bash

ACTION=$1
WINDOW_ID_FILE="/tmp/gpu_hover_window"

if [[ "$ACTION" == "toggle" ]]; then
    if [[ -f $WINDOW_ID_FILE ]]; then
        WINDOW_PID=$(cat $WINDOW_ID_FILE)

        wmctrl -ic $WINDOW_PID

        rm $WINDOW_ID_FILE
    else
        eval "$(xdotool getmouselocation --shell)"  

        yad --text "$(nvidia-smi)" --posx=$X --posy=$((Y + 20)) \
            --no-buttons --undecorated --fixed --skip-taskbar \
            --fontname="Roboto Mono 8" --close-on-unfocus --raise &

        WINDOW_ID=$(xdotool getactivewindow)

        echo $WINDOW_ID > $WINDOW_ID_FILE
    fi
fi 
