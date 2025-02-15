#!/bin/bash

ACTION=$1
WINDOW_ID_FILE="/tmp/ram_hover_window"

get_ram_info() {

    mem_info=$(free -h | grep Mem)
    buffers=$(free -h | grep -m 1 Buffers | awk '{print $3}')
    cached=$(free -h | grep -m 1 Buffers | awk '{print $4}')
    shared=$(free -h | grep -m 1 Buffers | awk '{print $5}')
    available=$(free -h | grep -m 1 Buffers | awk '{print $7}')
    
    echo "RAM Usage:"
    echo "$mem_info" | awk '{print "Total:", $2, "Used:", $3, "Free:", $4}'
    echo "$mem_info" | awk '{print "Shared:", $5, "Buff/Cache:", $6, "Available:", $7}'
    echo "----------------------------------------------------------"
    echo "Swap Usage:"
    free -h | grep Swap
}

get_process_list() {
    echo "PID (PPID) Command                     %RAM   %CPU"
    echo "----------------------------------------------------------"
    ps -eo pid,ppid,comm,%mem,%cpu --sort=-%mem | \
    awk 'NR>1 {printf "%-12s %-30s %-6s %-6s\n", $1 " (" $2 ")", $3, $4, $5}'
}

get_user_memory_usage() {
    echo "Memory Usage by User:"
    echo "---------------------------------------"
    ps -eo pid,uid,ppid,cmd,%mem --sort=-%mem | \
    awk 'NR>1 {a[$2]+=$5} END {for (i in a) {system("getent passwd " i " | cut -d: -f1"); printf "%s: %.2f%%\n", $1, a[i]}}' | \
    sort -rnk2 | head -n 5
}

if [[ "$ACTION" == "toggle" ]]; then
    if [[ -f $WINDOW_ID_FILE ]]; then

        WINDOW_PID=$(cat $WINDOW_ID_FILE)
        wmctrl -ic $WINDOW_PID
        rm $WINDOW_ID_FILE
    else

        eval "$(xdotool getmouselocation --shell)"

        FIFO="/tmp/ram_hover_fifo"
        rm -f "$FIFO"
        mkfifo "$FIFO"

        (
            while true; do
                printf "%s\n\n%s\n\n%s\n" "$(get_ram_info)" "$(get_process_list)" "$(get_user_memory_usage)" > "$FIFO"
                sleep 2
            done
        ) &

        yad --text-info --posx=$X --posy=$((Y + 20)) \
            --no-buttons --undecorated --fixed --skip-taskbar \
            --close-on-unfocus --width=400 --height=400 --fontname="monospace" \
            --wrap --fontname="Hack Nerd Font 10" --encoding=UTF-8 < "$FIFO" &

        WINDOW_ID=$(xdotool getactivewindow)
        echo $WINDOW_ID > $WINDOW_ID_FILE

        (sleep 5 && rm -f "$FIFO") &
    fi
fi
