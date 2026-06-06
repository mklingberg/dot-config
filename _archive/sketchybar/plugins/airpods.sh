#!/bin/bash
source "$HOME/.config/$BAR_NAME/theme.sh"
source "$HOME/.config/sketchybar/utils.sh"

WARNING_THRESHOLD=45
CRITICAL_THRESHOLD=20
COLOR=$COLOR_HEADPHONES

SHOW_LABEL=false

# airpods.sh
# Fetch the left and right battery status of connected AirPods and update the bar label with the lowest value

# Fetch AirPods battery levels
AIRPODS_INFO=$(system_profiler SPBluetoothDataType | grep -A 20 "AirPods")

# Extract left and right battery levels
LEFT_BATTERY=$(echo "$AIRPODS_INFO" | grep "Left Battery Level" | awk '{print $4}' | sed 's/%//' | tr -d '[:space:]')
RIGHT_BATTERY=$(echo "$AIRPODS_INFO" | grep "Right Battery Level" | awk '{print $4}' | sed 's/%//' | tr -d '[:space:]')

# Check if the extracted values are empty and set them to 0 if they are
LEFT_BATTERY=${LEFT_BATTERY:-0}
RIGHT_BATTERY=${RIGHT_BATTERY:-0}

# Determine the lowest battery level
LOWEST_BATTERY=$(( LEFT_BATTERY > 0 && LEFT_BATTERY < RIGHT_BATTERY ? LEFT_BATTERY : RIGHT_BATTERY ))

# Check if LOWEST_BATTERY is empty (AirPods not connected)
if [ "$LOWEST_BATTERY" -eq 0 ]; then
    # Hide the item if LOWEST_BATTERY is empty
    $BAR_NAME --set $NAME drawing=false
else
    # Determine the color based on battery level
    if [ $LOWEST_BATTERY -lt $CRITICAL_THRESHOLD ]; then
        COLOR=$COLOR_HEADPHONES_CRITICAL
        SHOW_LABEL=true
    elif [ $LOWEST_BATTERY -lt $WARNING_THRESHOLD ]; then
        COLOR=$COLOR_HEADPHONES_WARNING
        SHOW_LABEL=true
    fi

    LABEL_COLOR=$(fade_color $COLOR)
    # Show the item and set the label if LOWEST_BATTERY is not empty
    $BAR_NAME --set $NAME drawing=true label.drawing=$SHOW_LABEL label="$LOWEST_BATTERY%" icon=$ICON_AIRPODS icon.color=$COLOR label.color=$LABEL_COLOR
fi