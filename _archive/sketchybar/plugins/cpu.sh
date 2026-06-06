#!/bin/bash
COLOR_CPU_LOW=0xffee99a0
COLOR_CPU_MEDIUM=0xffed8796
COLOR_CPU_HIGH=0xffff0000

source "$HOME/.config/$BAR_NAME/theme.sh"

# Init default values
MEDIUM_THRESHOLD=60
HIGH_THRESHOLD=80
LABEL_THRESHOLD=40
SHOW_LABEL=false

# Get the total number of CPU cores
CORE_COUNT=$(sysctl -n machdep.cpu.thread_count)

# Get the CPU usage from the top command
CPU_USAGE=$(top -l 1 -n 0 | grep "CPU usage" | awk '{print $2 + $5}')

# Calculate the CPU percentage
CPU_PERCENT=$(echo "$CPU_USAGE" | awk '{printf "%.0f\n", $1}')

# Determine the color based on CPU usage
if [ $CPU_PERCENT -gt $HIGH_THRESHOLD ]; then
	ICON_COLOR=$COLOR_CPU_HIGH
elif [ $CPU_PERCENT -gt $MEDIUM_THRESHOLD ]; then
	ICON_COLOR=$COLOR_CPU_MEDIUM
else
	ICON_COLOR=$COLOR_CPU_LOW  # Default color
fi

if [ $CPU_PERCENT -gt $LABEL_THRESHOLD ]; then
  SHOW_LABEL=true
fi

# Update the bar with the CPU percentage and icon color
$BAR_NAME --set $NAME label="$CPU_PERCENT%" label.drawing=$SHOW_LABEL label.color=$ICON_COLOR icon.color=$ICON_COLOR