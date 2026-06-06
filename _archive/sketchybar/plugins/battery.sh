#!/bin/bash

COLOR_BATTERY_LOW=0xffee99a0
COLOR_BATTERY_EMPTY=0xffed8796
COLOR_BATTERY_ICON=0xffc7c7c7

source "$HOME/.config/$BAR_NAME/theme.sh"

LABEL_THRESHOLD=50
SHOW_LABEL=false
PERCENTAGE=$(pmset -g batt | grep -Eo "\d+%" | cut -d% -f1)
CHARGING=$(pmset -g batt | grep 'AC Power')

if [ $PERCENTAGE = "" ]; then
    exit 0
fi

# Set battery icon based on percentage
if [ $PERCENTAGE -eq 100 ]; then
  ICON=$ICON_BATTERY_100
elif [ $PERCENTAGE -ge 75 ]; then
    ICON=$ICON_BATTERY_75
elif [ $PERCENTAGE -ge 50 ]; then
    ICON=$ICON_BATTERY_50
elif [ $PERCENTAGE -ge 25 ]; then
    ICON=$ICON_BATTERY_25
    COLOR_BATTERY_ICON=$COLOR_BATTERY_LOW
else
    ICON=$ICON_BATTERY_0
    COLOR_BATTERY_ICON=$COLOR_BATTERY_EMPTY
fi

# Show label if percentage is less than x%
if [ $PERCENTAGE -lt $LABEL_THRESHOLD ]; then
  SHOW_LABEL=true
fi

if [[ $CHARGING != "" ]]; then
    ICON=""
fi

$BAR_NAME --set $NAME \
    icon=$ICON \
    label="${PERCENTAGE}%" \
    label.drawing=$SHOW_LABEL \
    icon.color=$COLOR_BATTERY_ICON \
    label.color=$COLOR_BATTERY_ICON
