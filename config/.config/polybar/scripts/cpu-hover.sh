#!/bin/bash

ACTION=$1
WINDOW_ID_FILE="/tmp/cpu_hover_window"

# Function to get relevant CPU info (excluding BogoMIPS and below)
get_cpu_info() {
    lscpu | awk '/BogoMIPS/ {exit} {print}'
}

# Function to get a small live process list (like top, but smaller)
get_process_list() {
    ps -eo pid,comm,%cpu --sort=-%cpu | head -n 6  # Top 5 CPU-heavy processes
}

if [[ "$ACTION" == "toggle" ]]; then
    if [[ -f $WINDOW_ID_FILE ]]; then
        # Close the window if it's running
        WINDOW_PID=$(cat $WINDOW_ID_FILE)
        wmctrl -ic $WINDOW_PID
        rm $WINDOW_ID_FILE
    else
        # Get mouse position
        eval "$(xdotool getmouselocation --shell)"

        # Create a temporary FIFO file to stream live updates
        FIFO="/tmp/cpu_hover_fifo"
        rm -f "$FIFO"
        mkfifo "$FIFO"

        # Start background process to update info dynamically (without stacking)
        (
            while true; do
                printf "%s\n\nTop CPU Processes:\n%s\n" "$(get_cpu_info)" "$(get_process_list)" > "$FIFO"
                sleep 2
            done
        ) &

        # Open YAD window with live data (forcing UTF-8 encoding)
        yad --text-info --posx=$X --posy=$((Y + 20)) \
            --no-buttons --undecorated --fixed --skip-taskbar \
            --close-on-unfocus --width=600 --height=300 --fontname="monospace" \
            --wrap --fontname="Hack Nerd Font 10" --encoding=UTF-8 < "$FIFO" &

        # Store the window ID
        WINDOW_ID=$(xdotool getactivewindow)
        echo $WINDOW_ID > $WINDOW_ID_FILE

        # Clean up FIFO when the window closes
        (sleep 5 && rm -f "$FIFO") &
    fi
fi
