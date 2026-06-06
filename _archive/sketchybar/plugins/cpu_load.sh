#!/bin/bash
COLOR_CPU_LOW=0xffee99a0
COLOR_CPU_MEDIUM=0xffed8796
COLOR_CPU_HIGH=0xffff0000

source "$HOME/.config/$BAR_NAME/theme.sh"

# Init default values
MEDIUM_THRESHOLD=8.0
HIGH_THRESHOLD=12.0

# Refresh rate
UPDATE_FREQ_STANDBY=15
UPDATE_FREQ_HI=5
UPDATE_FREQ=$UPDATE_FREQ_STANDBY

ICON_COLOR=$COLOR_CPU_LOW
ICON=$ICON_CPU_LOAD_1

# Get the total number of CPU cores
STATS=$(top -l 1 -n 0)

# Extract Load Avg values 
LOAD_AVG=$(echo "$STATS" | grep "Load Avg" | awk -F'[:,]' '{print $2}' | xargs)
#LOAD_AVG=20.0


# Determine the color based on CPU usage
if (( $(echo "$LOAD_AVG > $HIGH_THRESHOLD" | bc -l) )); then
    ICON_COLOR=$COLOR_CPU_HIGH
    UPDATE_FREQ=$UPDATE_FREQ_HI
elif (( $(echo "$LOAD_AVG > $MEDIUM_THRESHOLD" | bc -l) )); then
    ICON_COLOR=$COLOR_CPU_MEDIUM
    UPDATE_FREQ=$UPDATE_FREQ_HI
fi

# Determine the icon based on CPU usage
if (( $(echo "$LOAD_AVG > 14.0" | bc -l) )); then
    ICON=$ICON_CPU_LOAD_10
elif (( $(echo "$LOAD_AVG > 13.0" | bc -l) )); then
    ICON=$ICON_CPU_LOAD_9
elif (( $(echo "$LOAD_AVG > 12.0" | bc -l) )); then
    ICON=$ICON_CPU_LOAD_8
elif (( $(echo "$LOAD_AVG > 11.0" | bc -l) )); then
    ICON=$ICON_CPU_LOAD_7
elif (( $(echo "$LOAD_AVG > 10.0" | bc -l) )); then
    ICON=$ICON_CPU_LOAD_6
elif (( $(echo "$LOAD_AVG > 9.0" | bc -l) )); then
    ICON=$ICON_CPU_LOAD_5
elif (( $(echo "$LOAD_AVG > 8.0" | bc -l) )); then
    ICON=$ICON_CPU_LOAD_4
elif (( $(echo "$LOAD_AVG > 7.0" | bc -l) )); then
    ICON=$ICON_CPU_LOAD_3
elif (( $(echo "$LOAD_AVG > 6.0" | bc -l) )); then
    ICON=$ICON_CPU_LOAD_2
else
    ICON=$ICON_CPU_LOAD_1
fi

cpu=(
    icon=$ICON
    icon.color=$ICON_COLOR
    update_freq=$UPDATE_FREQ
)

# Update the bar with the CPU percentage and icon color
$BAR_NAME --set $NAME "${cpu[@]}"