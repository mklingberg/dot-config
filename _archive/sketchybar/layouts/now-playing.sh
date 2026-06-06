#!/bin/bash
source "$HOME/.config/$BAR_NAME/theme.sh"

# Global settings

PLUGIN_DIR="$HOME/.config/sketchybar/plugins-desktop"
PLUGIN_SHARED_DIR="$HOME/.config/sketchybar/plugins"
ITEM_DIR="$CONFIG_DIR/items"

BAR_HEIGHT=400
MARGIN_RIGHT=8

bar=(
    height=$BAR_HEIGHT
    color=$TRANSPARENT
    display=main
    topmost=on
    position=bottom
    hidden=off
    #margin=0
    padding_right=0
)

default=(
    background.height=$BAR_HEIGHT
)

spacer_right=(
    width=$MARGIN_RIGHT
    background.height=$BAR_HEIGHT
    label.drawing=off
)

icon=(
    icon.width=180
    background.padding_right=-180
    icon.color=0xeeffffff
    icon.y_offset=76
    icon.align=right
    icon=$COLOR_NOW_PLAYING_ICON
    icon.font.size=32
)

thumbnail=(
    background.height=200
    icon.width=200
    background.padding_left=-14
    background.drawing=on
    background.image="media.artwork"
    background.image.corner_radius=20
    background.image.scale=6.20
    background.image.y_offset=0
    script="$PLUGIN_SHARED_DIR/now_playing_player.sh"
)

artist=(
    background.padding_right=-200
    label.width=200
    background.height=20
    scroll_texts=on
    label="Artist"
    #label.padding_right=20
    label.padding_left=-20
    label.max_chars=26
    label.align=center
    label.y_offset=-132
    label.font.size=12
    label.color=$COLOR_NOW_PLAYING_ARTIST
)

track=(
    background.padding_right=-200
    label.width=200
    background.height=20
    scroll_texts=on
    label="Track"
    #label.padding_right=20
    label.padding_left=-20
    label.max_chars=20
    label.align=center
    label.y_offset=-114
    label.font.style=Bold
    label.font.size=14
    label.color=$COLOR_NOW_PLAYING_TRACK
)

toggle=(
    background.padding_right=-22
    icon.color=$COLOR_NOW_PLAYING_CLOSE
    icon.y_offset=-18
    icon.align=left
    icon.padding_right=0
    icon=$ICON_NOW_PLAYING_CLOSE
    icon.font.size=32
    script="$PLUGIN_SHARED_DIR/now_playing_toggle.sh"
)

wrapper=(
    background.height=254
    background.y_offset=-18
    background.color=$COLOR_NOW_PLAYING_BG
)

wrapper_rounded=(
    background.height=254
    background.corner_radius=26
    background.y_offset=-18
    background.color=$COLOR_NOW_PLAYING_BG
)

$BAR_NAME \
    --bar "${bar[@]}" \
    --default "${default[@]}" \
    --add event set_visible \
    --add event set_hidden \
    --add event set_enabled \
    --add event set_disabled \
    --add event toggle_hidden \
    --add event toggle_enabled \
    --add event toggle_player_change \
    --add item spacer_outer right \
    --set spacer_outer "${spacer_right[@]}" \
    --add item spacer_1 right \
    --set spacer_1 \
        width=8 \
        label.drawing=off \
    --add item thumbnail right \
    --set thumbnail "${thumbnail[@]}" \
    --subscribe thumbnail mouse.clicked media_change \
    --add item artist right \
    --set artist "${artist[@]}" \
    --add item track right \
    --set track "${track[@]}" \
    --add item icon right \
    --set icon "${icon[@]}" \
    --add item spacer_2 right \
    --set spacer_2 \
        width=22 \
        label.drawing=off \
    --add item toggle right \
    --set toggle "${toggle[@]}" \
    --subscribe toggle mouse.clicked set_visible set_hidden set_enabled set_disabled toggle_hidden toggle_enabled toggle_player_change \
    --add bracket wrapper \
        spacer_outer \
        spacer_1 \
        icon \
        thumbnail \
        artist \
        track \
    --set wrapper "${wrapper[@]}" \
    --add bracket wrapper_rounded \
        thumbnail \
        spacer_2 \
    --set wrapper_rounded "${wrapper_rounded[@]}"

$BAR_NAME --update