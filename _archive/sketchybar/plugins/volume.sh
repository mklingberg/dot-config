#!/bin/bash
COLOR_VOLUME_LOW=0xffee99a0
COLOR_VOLUME_MEDIUM=0xffed8796
COLOR_VOLUME_HIGH=0xffff0000

source "$HOME/.config/sketchybar/utils.sh"
source "$HOME/.config/$BAR_NAME/theme.sh"

SHOW_LABEL=false
#ICON_PADDING_RIGHT=10
ICON_COLOR=$COLOR_VOLUME_LOW  # Default color

LABEL_TRANSPARENCY=99

case ${INFO} in
0)
    ICON="󰖁"
    SHOW_LABEL=false
    ;;
[1-9]|[1-4][0-9])
    ICON="󰖀"
    SHOW_LABEL=true
    ;;
[5-7][0-9])
    ICON="󰕾"
    SHOW_LABEL=true
    ;;
[8-9][0-9]|100)
    ICON=""
    SHOW_LABEL=true
    ;;
esac

case ${INFO} in
[7][0-9])
    ICON_COLOR=$COLOR_VOLUME_MEDIUM
    ;;
[8-9][0-9]|100)
    ICON_COLOR=$COLOR_VOLUME_HIGH
    ;;
esac

LABEL_COLOR=$(fade_color $ICON_COLOR)

volume=(
    icon=$ICON
    label.drawing=$SHOW_LABEL
    label="$INFO%"
    label.color=$LABEL_COLOR
    icon.color=$ICON_COLOR
    click_script='osascript -e "set volume output muted not (output muted of (get volume settings))"'
)

$BAR_NAME --set $NAME "${volume[@]}" \