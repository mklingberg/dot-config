#!/usr/bin/env bash
source "$HOME/.config/$BAR_NAME/theme.sh" # Loads all defined colors

ID=$1
MONITOR_ID=$2

if [ "$MONITOR_ID" != "$FOCUSED_MONITOR" ]; then
    # If this event is not targeting this monitor, we want to keep selected state!
    exit 0
fi

if [ "$ID" = "$FOCUSED_WORKSPACE" ]; then
    $BAR_NAME \
        --set workspace."$ID" \
            background.color=$COLOR_SPACE_SELECTED_BG \
        --set workspaces."$ID" \
            icon.color=$COLOR_SPACE_SELECTED_SPACE_NO \
            icon.font.style=Bold \
            background.color=$COLOR_SPACE_SELECTED_SPACE_NO_BG \
        --set workspaces."$ID".windows \
            label.color=$COLOR_SPACE_SELECTED_ICON
else
    $BAR_NAME \
        --set workspace."$ID" \
            background.color=$COLOR_SPACE_BG \
        --set workspaces."$ID" \
            icon.color=$COLOR_SPACE_SPACE_NO \
            icon.font.style=Medium \
            background.color=$COLOR_SPACE_SPACE_NO_BG \
        --set workspaces."$ID".windows \
            label.color=$COLOR_SPACE_ICON
fi