#!/bin/bash

COLOR_BREW_OUTDATED=0xffed8796
COLOR_BREW_HIGH=0xfff5a97f
COLOR_BREW_MEDIUM=0xffeed49f
COLOR_BREW_LOW=0xffcad3f5
COLOR_BREW_UPDATED=0xffa6da95

source "$HOME/.config/$BAR_NAME/theme.sh"
source "$HOME/.config/sketchybar/utils.sh"

# Function to check for outdated brew packages
check_brew_outdated() {
    # Remove lines starting with "==>" and count the remaining lines
    COUNT=$(brew outdated | grep -v '^==>' | wc -l | awk '{print $1}')
    # echo "COUNT: $COUNT"

    # If there was an error getting outdated packages, exit
    # just showing previous value
    if [ -z "$COUNT" ]; then
        return 0
    fi

    COLOR=$COLOR_BREW_OUTDATED
    SHOW_LABEL=true

    ICON=$ICON_BREW

    if [ $COUNT -eq 0 ]; then
        COLOR=$COLOR_BREW_UPDATED
        ICON=$ICON_BREW_UPDATED
        SHOW_LABEL=false
    elif [ $COUNT -lt 10 ]; then
        COLOR=$COLOR_BREW_LOW
    elif [ $COUNT -lt 20 ]; then
        COLOR=$COLOR_BREW_MEDIUM
    else
        COLOR=$COLOR_BREW_HIGH
    fi

    LABEL_COLOR=$(fade_color $COLOR)

    $BAR_NAME --set $NAME label=$COUNT icon=$ICON label.drawing=$SHOW_LABEL icon.color=$COLOR label.color=$LABEL_COLOR
}

# Check if the script was triggered by a click
if [ "$SENDER" = "mouse.clicked" ]; then
    check_brew_outdated
    exit 0
fi

# Regular update
check_brew_outdated
