#!/bin/bash
source "$HOME/.config/$BAR_NAME/theme.sh"

WARNING_THRESHOLD=45
CRITICAL_THRESHOLD=20
COLOR=$COLOR_HEADPHONES_CASE

SHOW_LABEL=false

# airpods.sh
# Fetch the left and right battery status of connected AirPods and update the bar label with the lowest value

# Fetch AirPods battery levels
AIRPODS_INFO=$(system_profiler SPBluetoothDataType | grep -A 20 "AirPods")

CASE_BATTERY=$(echo "$AIRPODS_INFO" | grep "Case Battery Level" | awk '{print $4}' | sed 's/%//' | tr -d '[:space:]')

# Check if the extracted values are empty and set them to 0 if they are
CASE_BATTERY=${CASE_BATTERY:-0}

# Check if we have a value for case battery, but not airpods then show it
if [ "$CASE_BATTERY" -gt 0 ]; then

    # Determine the color based on battery level
    if [ $CASE_BATTERY -lt $CRITICAL_THRESHOLD ]; then
        COLOR=$COLOR_HEADPHONES_CASE_CRITICAL
        SHOW_LABEL=true
    elif [ $CASE_BATTERY -lt $WARNING_THRESHOLD ]; then
        COLOR=$COLOR_HEADPHONES_CASE_WARNING
        SHOW_LABEL=true
    fi

    $BAR_NAME --set $NAME drawing=true label="$CASE_BATTERY%" label.drawing=$SHOW_LABEL icon=$ICON_AIRPODS_CASE icon.color=$COLOR
else
    $BAR_NAME --set $NAME drawing=falsel
fi