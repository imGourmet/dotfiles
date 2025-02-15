#!/bin/bash

WINDOW_ID_FILE="/tmp/podcast_window_id"

if [[ -f $WINDOW_ID_FILE ]]; then
    WINDOW_PID=$(cat $WINDOW_ID_FILE)
    wmctrl -ic $WINDOW_PID
    rm $WINDOW_ID_FILE
else
    eval "$(xdotool getmouselocation --shell)"

    # Display a temporary message using yad with the specified icon and color
    yad --text="<span foreground='#EBCB8B' font='9'></span> <span foreground='#D8DEE9' font='9'>Podcast launched...</span>" \
        --posx=$X --posy=$((Y + 20)) \
        --no-buttons --undecorated --fixed --skip-taskbar \
        --close-on-unfocus --width=100 --height=10 --timeout=3 &

    WINDOW_ID=$(xdotool getactivewindow)
    echo $WINDOW_ID > $WINDOW_ID_FILE
fi

# Load and play the latest episodes playlist
echo "add /home/andrew/vlc/podcasts/latest_episodes.xspf" | socat - ~/.config/vlc/vlc.sock
