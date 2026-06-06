#!/bin/bash


#
COLOR_RELOAD_ENTERED=0xffa6da95
COLOR_RELOAD_EXITED=0xfff5a97f

source "$HOME/.config/$BAR_NAME/theme.sh"

# Update scripts/events are not run when the bar is hidden
# so we use offset to hide the bar, allowing the script to run
# even if the bar is "hidden"
DEFAULT_Y_OFFSET=0
HIDDEN_Y_OFFSET=-1000

case "$SENDER" in
"mouse.clicked") # | "power_source_change" | "system_woke"
    # Reload sketchybar
    $BAR_NAME --remove '/.*/'
    source $HOME/.config/$BAR_NAME/sketchybarrc
    ;;
"set_visible")
    $BAR_NAME --bar y_offset=$DEFAULT_Y_OFFSET
    ;;

"set_hidden")
    $BAR_NAME --bar y_offset=$HIDDEN_Y_OFFSET
    ;;
esac