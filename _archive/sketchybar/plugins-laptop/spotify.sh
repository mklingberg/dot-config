#!/bin/bash

COLOR_SPOTIFY=0xffeed49f
COLOR_SPOTIFY_PAUSE=0xffeed49f
COLOR_SPOTIFY_ICON=$COLOR_SPOTIFY
ICON_SPOTIFY=
ICON_SPOTIFY_PAUSE=
ICON_SPOTIFY_PLAY= #

source "$HOME/.config/$BAR_NAME/theme.sh"

MAX_LENGTH=50

# Logic starts here, do not modify
HALF_LENGTH=$(((MAX_LENGTH + 1) / 2))

# Spotify JSON / $INFO comes in malformed, line below sanitizes it
SPOTIFY_JSON="$INFO"

update_track() {

    if [[ -z $SPOTIFY_JSON ]]; then
        $BAR_NAME --set $NAME \
                    icon=$ICON_SPOTIFY \
                    icon.color=$COLOR_SPOTIFY_ICON \
                    label.drawing=no
        return
    fi

    PLAYER_STATE=$(echo "$SPOTIFY_JSON" | jq -r '.["Player State"]')

    if [ $PLAYER_STATE = "Playing" ]; then
        TRACK="$(echo "$SPOTIFY_JSON" | jq -r .Name)"
        ARTIST="$(echo "$SPOTIFY_JSON" | jq -r .Artist)"

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

        $BAR_NAME --set $NAME \
                    icon=$ICON_SPOTIFY_PLAY \
                    label="${TRACK} - ${ARTIST}" \
                    label.drawing=yes \
                    icon.color=$COLOR_SPOTIFY_ICON \
                    label.color=$COLOR_SPOTIFY
                

    elif [ $PLAYER_STATE = "Paused" ]; then
        $BAR_NAME --set $NAME \
                    icon=$ICON_SPOTIFY_PAUSE \
                    icon.color=$COLOR_SPOTIFY_ICON \
                    label.drawing=yes \
                    label.color=$COLOR_SPOTIFY_PAUSE
    elif [ $PLAYER_STATE = "Stopped" ]; then
        $BAR_NAME --set $NAME \
                     icon=$ICON_SPOTIFY \
                     icon.color=$COLOR_SPOTIFY_ICON \
                     label.drawing=no
    else
        $BAR_NAME --set $NAME \
                     icon=$ICON_SPOTIFY \
                     icon.color=$COLOR_SPOTIFY_ICON \
                     label.color=$COLOR_SPOTIFY
                    
    fi
}

case "$SENDER" in
"mouse.clicked")
    osascript -e 'tell application "Spotify" to playpause'
    ;;
*)
    update_track
    ;;
esac
