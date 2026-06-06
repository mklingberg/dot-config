#!/bin/bash

source "$HOME/.config/$BAR_NAME/theme.sh"

update_media_changed() {
    PLAYER_STATE="$(echo "$INFO" | jq -r .state)"
    TITLE="$(echo "$INFO" | jq -r .title)"
    ARTIST="$(echo "$INFO" | jq -r .artist)"
    APP="$(echo "$INFO" | jq -r .app)"
    
    # Only show playback for spotify as of now
    if [ "$APP" != "Spotify" ]; then
        # Hide now playing bar if not spotify
        $BAR_NAME --trigger set_hidden
        return 0
    fi

    ICON=$ICON_NOW_PLAYING

    if [ "$PLAYER_STATE" = "playing" ]; then
        ICON=$ICON_NOW_PLAYING_SPOTIFY
    elif [ "$PLAYER_STATE" = "paused" ]; then
        ICON=$ICON_NOW_PLAYING_PAUSED
    elif [ "$PLAYER_STATE" = "stopped" ]; then
        $BAR_NAME --trigger set_hidden
        #ICON=$ICON_NOW_PLAYING_STOPPED
        return 0
    fi

    $BAR_NAME \
        --trigger toggle_player_change \
        --set artist label="$ARTIST" \
        --set track label="$TITLE" \
        --set icon icon=$ICON
}

case "$SENDER" in
    "mouse.clicked")
        osascript -e 'tell application "Spotify" to playpause'
        ;;
    "media_change")
        update_media_changed
        ;;
esac
