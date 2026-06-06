#!/bin/bash
source "$HOME/.config/$BAR_NAME/theme.sh"

MAX_LENGTH=80

# Logic starts here, do not modify
HALF_LENGTH=$(((MAX_LENGTH + 1) / 2))

update_media_changed() {
    PLAYER_STATE="$(echo "$INFO" | jq -r .state)"
    APP="$(echo "$INFO" | jq -r .app)"

    echo "PLAYER_STATE: $PLAYER_STATE"
    echo "APP: $APP"

    if [ "$PLAYER_STATE" = "playing" ]; then

        TRACK="$(echo "$INFO" | jq -r .title)"
        ARTIST="$(echo "$INFO" | jq -r .artist)"

        # Calculations so it fits nicely
        TRACK_LENGTH=${#TRACK}
        ARTIST_LENGTH=${#ARTIST}

        if [ $((TRACK_LENGTH + ARTIST_LENGTH)) -gt $MAX_LENGTH ]; then
            # If the total length exceeds the max
            if [ $TRACK_LENGTH -gt $HALF_LENGTH ] && [ $ARTIST_LENGTH -gt $HALF_LENGTH ]; then
                # If both the track and artist are too long, cut both at half length - 1

                # If MAX_LENGTH is odd, HALF_LENGTH is calculated with an extra space, so give it an extra char
                TRACK="${TRACK:0:$((MAX_LENGTH % 2 == 0 ? HALF_LENGTH - 2 : HALF_LENGTH - 1))}…"
                ARTIST="${ARTIST:0:$((HALF_LENGTH - 2))}…"

            elif [ $TRACK_LENGTH -gt $HALF_LENGTH ]; then
                # Else if only the track is too long, cut it by the difference of the max length and artist length
                TRACK="${TRACK:0:$((MAX_LENGTH - ARTIST_LENGTH - 1))}…"
            elif [ $ARTIST_LENGTH -gt $HALF_LENGTH ]; then
                ARTIST="${ARTIST:0:$((MAX_LENGTH - TRACK_LENGTH - 1))}…"
            fi
        fi

        ICON=$ICON_NOW_PLAYING_PLAYING

        if [ "$APP" = "Spotify" ]; then
            ICON=$ICON_NOW_PLAYING_SPOTIFY
        fi
        
        $BAR_NAME --set $NAME \
            label.drawing=yes \
            label="${TRACK} - ${ARTIST}" \
            icon=$ICON
            
    elif [ "$PLAYER_STATE" = "paused" ]; then
        $BAR_NAME --set $NAME \
            label.drawing=yes \
            icon=$ICON_NOW_PLAYING_PAUSED

    elif [ "$PLAYER_STATE" = "stopped" ]; then
        $BAR_NAME --set $NAME \
            label.drawing=no \
            icon=$ICON_NOW_PLAYING_STOPPED
    fi
}

case "$SENDER" in
    "mouse.clicked")
        osascript -e 'tell application "Spotify" to playpause'
        ;;
    "media_change")
        update_media_changed
        ;;
esac
