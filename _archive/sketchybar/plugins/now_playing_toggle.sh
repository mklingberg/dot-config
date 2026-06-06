#!/bin/bash
source "$HOME/.config/$BAR_NAME/theme.sh"

show() {
    $BAR_NAME \
        --set thumbnail drawing=on \
        --set icon drawing=on \
        --set artist drawing=on \
        --set track drawing=on \
        --set wrapper drawing=on \
        --set wrapper_rounded drawing=on \
        --set spacer_outer drawing=on \
        --set spacer_1 drawing=on \
        --set spacer_2 drawing=on \
        --set toggle icon=$ICON_NOW_PLAYING_CLOSE \
                     icon.font.size=32 \
                     icon.color=$COLOR_NOW_PLAYING_CLOSE \
                     background.padding_right=-22
}

hide() {
    $BAR_NAME \
        --set thumbnail drawing=off \
        --set icon drawing=off \
        --set artist drawing=off \
        --set track drawing=off \
        --set wrapper drawing=off \
        --set wrapper_rounded drawing=off \
        --set spacer_outer drawing=on \
        --set spacer_1 drawing=off \
        --set spacer_2 drawing=off \
        --set toggle icon=$ICON_NOW_PLAYING_OPEN \
                     icon.font.size=82 \
                     icon.color=$COLOR_NOW_PLAYING_OPEN \
                     background.padding_right=-20
}

toggle_hidden() {
    CURRENT_ICON=$($BAR_NAME --query toggle | jq -r .icon.value)
    if [ "$CURRENT_ICON" = "$ICON_NOW_PLAYING_OPEN" ]; then
        show
    else
        hide
    fi
}

case "$SENDER" in
    "toggle_player_change")
        CURRENT_ICON=$($BAR_NAME --query toggle | jq -r .icon.value)
        if [ "$CURRENT_ICON" = "$ICON_NOW_PLAYING_OPEN" ]; then
            # If the player is closed on media change, then open it to show updated playback info
            # and close it again after a delay..."
            show
            sleep 8
            hide
        fi
        ;;
    "set_visible")
        show
        ;;
    "set_hidden")
        hide
        ;;
    "set_enabled")
        $BAR_NAME --bar hidden=off
        show
        ;;
    "set_disabled")
        $BAR_NAME --bar hidden=on
        ;;
    "toggle_enabled")
        HIDDEN=$($BAR_NAME --query bar | jq -r .hidden)
        if [ "$HIDDEN" = "on" ]; then
            $BAR_NAME \
                --bar hidden=off \
                --trigger media_change
        else
            $BAR_NAME --bar hidden=on
        fi
        ;;
    "toggle_hidden")
        toggle_hidden
        ;;
    "mouse.clicked")
        toggle_hidden
        ;;
esac