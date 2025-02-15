#!/bin/bash

ACTION=$1
WINDOW_ID_FILE="/tmp/cpu_hover_window"

get_cpu_info() {
    lscpu | awk '/BogoMIPS/ {exit} {print}'
}

get_process_list() {
    ps -eo pid,comm,%cpu --sort=-%cpu | head -n 6  
}

if [[ "$ACTION" == "toggle" ]]; then
    if [[ -f $WINDOW_ID_FILE ]]; then
        WINDOW_PID=$(cat $WINDOW_ID_FILE)
        wmctrl -ic $WINDOW_PID
        rm $WINDOW_ID_FILE
    else
        eval "$(xdotool getmouselocation --shell)"

        FIFO="/tmp/cpu_hover_fifo"
        rm -f "$FIFO"
        mkfifo "$FIFO"

        (
            while true; do
                printf "%s\n\nTop CPU Processes:\n%s\n" "$(get_cpu_info)" "$(get_process_list)" > "$FIFO"
                sleep 2
            done
        ) &

        yad --text-info --posx=$X --posy=$((Y + 20)) \
            --no-buttons --undecorated --fixed --skip-taskbar \
            --close-on-unfocus --width=600 --height=300 --fontname="monospace" \
            --wrap --fontname="Roboto Mono 10" --encoding=UTF-8 < "$FIFO" &

        WINDOW_ID=$(xdotool getactivewindow)
        echo $WINDOW_ID > $WINDOW_ID_FILE

        (sleep 5 && rm -f "$FIFO") &
    fi
fi
