#!/bin/bash
source "$HOME/.config/$BAR_NAME/theme.sh"
source "$HOME/.config/sketchybar/plugins/aerospace_windows.sh" $MONITOR_ID

# Global settings

PLUGIN_DIR="$HOME/.config/sketchybar/plugins-desktop"
PLUGIN_SHARED_DIR="$HOME/.config/sketchybar/plugins"
ITEM_DIR="$CONFIG_DIR/items"

SPOTIFY_EVENT="com.spotify.client.PlaybackStateChanged"

BAR_HEIGHT=40
SEPARATOR_WIDTH=12
DEFAULT_PADDING=1

DEFAULT_RADIUS=12
INNER_RADIUS=10

OUTER_HEIGHT=24
INNER_HEIGHT=20

CENTER_HEIGHT=22
CENTER_OUTER_HEIGHT=28
CENTER_RADIUS=14
CENTER_DEFAULT_RADIUS=14

FRONT_APP_ICON_SIZE=14
FRONT_APP_NAME_SIZE=15


# MAIN BAR

bar=(
    height=$BAR_HEIGHT
    color=$COLOR_BAR_BG
    margin=0
    padding_left=8
    padding_right=8
    display=$DISPLAY_NUMBER
    #topmost=on
    #hidden=on
    #y_offset=-1000
)

default=(
    background.height=$BAR_HEIGHT
    icon.color=$COLOR_TEXT
    icon.font="$FONT_FACE:Medium:16.0"
    icon.padding_left=0
    icon.padding_right=0
    icon.y_offset=0
    label.color=$COLOR_TEXT
    label.font="$FONT_FACE:Medium:14.0"
    label.y_offset=1
    label.padding_left=0
    label.padding_right=0
)

$BAR_NAME \
    --bar "${bar[@]}" \
    --default "${default[@]}"


# LEFT SECTION

screen=(
    icon=$ICON_APPLE
    icon.color=$COLOR_RELOAD_ICON
    icon.y_offset=1
    icon.padding_right=5
    label=$DISPLAY_NUMBER
    background.padding_left=10
    background.padding_right=10
    script="$PLUGIN_SHARED_DIR/reload.sh"
)

## Utils12

cpu_user=(
    icon=$ICON_CPU_IDLE
    icon.color=$COLOR_STATS
    icon.padding_right=5
    icon.padding_left=5
    label.color=$COLOR_STATS
    label.padding_right=5
    background.padding_left=10
    background.padding_right=5
    script="$PLUGIN_SHARED_DIR/cpu_load_label.sh"
)

brew=(
    icon=$ICON_BREW
    update_freq=120
    icon.padding_left=8
    icon.padding_right=10
    label.padding_right=10
    label.drawing=off
    background.height=$INNER_HEIGHT
    background.corner_radius=$DEFAULT_RADIUS
    background.color=$COLOR_BREW_BG
    script="$PLUGIN_SHARED_DIR/brew.sh"
)

## Render bar section

$BAR_NAME \
    --add event set_visible \
    --add event set_hidden \
    --add item screen left \
    --set screen "${screen[@]}" \
    --subscribe screen mouse.clicked set_visible set_hidden \
    --add item cpu_user left \
    --set cpu_user "${cpu_user[@]}" \
    --add event brew_update \
    --add item brew left \
    --set brew "${brew[@]}" \
    --subscribe brew brew_update mouse.clicked \
    --add item separator_utils_1 left \
    --add bracket left_bracket \
            screen \
            cpu_user \
            brew \
            separator_utils_1 \
    --set left_bracket \
            background.height=$OUTER_HEIGHT \
            background.corner_radius=$DEFAULT_RADIUS \
            background.padding_right=10 \
            background.padding_left=10 \
            background.color=$COLOR_RELOAD_BG \
    --add bracket left_bracket2 \
            cpu_user \
            brew \
    --set left_bracket2 \
            background.height=$INNER_HEIGHT \
            background.corner_radius=$INNER_RADIUS \
            background.padding_right=10 \
            background.padding_left=10 \
            background.color=$COLOR_UTILS_BG


# CENTER SECTION

## Spotify

spotify=(
    icon=$ICON_SPOTIFY
    icon.font="$FONT_FACE:Medium:22.0"
    icon.color=$COLOR_SPOTIFY_ICON
    icon.padding_right=0
    icon.padding_left=0
    label.color=$COLOR_SPOTIFY
    label.drawing=off
    label.y_offset=0
    label.font="$FONT_FACE:Medium:16.0"
    label.padding_left=10
    label.padding_right=0
    background.padding_left=26
    background.padding_right=18
    background.height=$CENTER_HEIGHT
    script="$PLUGIN_DIR/spotify.sh"
)

$BAR_NAME \
    --add event spotify_change $SPOTIFY_EVENT \
    --add item spotify center \
    --set spotify "${spotify[@]}" \
    --subscribe spotify spotify_change mouse.clicked \
    --add item separator_now_playing_2 center \
    --add bracket spotify_bracket \
            spotify \
    --set spotify_bracket \
            background.height=$CENTER_HEIGHT \
            background.corner_radius=$CENTER_RADIUS \
            background.padding_right=10 \
            background.padding_left=10

## Aerospace workspaces
$BAR_NAME \
    --add event aerospace_workspace_change \
    --add event aerospace_workspace_reload \
    --add event aerospace_window_moved \
    --add item workspaces_spacer_1 center \
    --set      workspaces_spacer_1 \
                    width=20 \
                    label.drawing=off

# Fetch workspaces visible on this display/monitor
MONITOR_WORKSPACES=( $(aerospace list-workspaces --monitor $MONITOR_ID) )
ADD_SPACER=false

for ID in ${MONITOR_WORKSPACES[@]}; do
    # Only add spacer between workspaces
    if [ "$ADD_SPACER" = true ]; then
        $BAR_NAME \
            --add item  workspace_spacer_"$ID" center \
            --set       workspace_spacer_"$ID" \
                        width=1 \
                        label.drawing=off
    fi

    workspace_no=(
        click_script="aerospace workspace $ID"
        icon="$ID"
    )

    workspace_windows=(
        click_script="aerospace workspace $ID"
        icon.drawing=off
        icon.y_offset=1
        label.font="sketchybar-app-font:Regular:14.0"
        label.y_offset=-1
        label=" —"
        label.padding_left=0
        label.padding_right=20
        script="$PLUGIN_SHARED_DIR/aerospace_focus.sh $ID $MONITOR_ID"
    )
    
    $BAR_NAME \
        --add item  workspaces."$ID" center \
        --set       workspaces."$ID" "${workspace_no[@]}" \
        --add item  workspaces."$ID".windows center \
        --subscribe workspaces."$ID".windows aerospace_workspace_change \
        --set       workspaces."$ID".windows "${workspace_windows[@]}"

     ADD_SPACER=true   
done

$BAR_NAME \
    --add item  workspaces_spacer_2 center \
    --subscribe workspaces_spacer_2 aerospace_workspace_change aerospace_window_moved aerospace_workspace_reload\
    --set       workspaces_spacer_2 \
                script="$PLUGIN_SHARED_DIR/aerospace_windows.sh $MONITOR_ID" \
                width=20 \
                label.drawing=off

front_app=(
    icon.font="sketchybar-app-font:Regular:22.0"
    icon.color=$COLOR_FRONT_APP_ICON
    label.drawing=no
    background.padding_right=10
    background.padding_left=20
    script="$PLUGIN_SHARED_DIR/front_app.sh"
)

front_app_name=(
    icon.drawing=off
    label.y_offset=0
    label.font="$FONT_FACE:Medium:16.0"
    background.padding_right=26
    background.padding_left=0
    label.color=$COLOR_FRONT_APP_NAME
)

## Render bar section

$BAR_NAME \
    --add item front_app center \
    --set front_app "${front_app[@]}" \
    --add item front_app.name center \
    --set front_app.name "${front_app_name[@]}" \
    --add bracket front_app_bracket \
            front_app \
            front_app.name \
    --set front_app_bracket \
            background.padding_right=10 \
            background.padding_left=10 \
    --subscribe front_app front_app_switched mouse.clicked \
    --add bracket center_bracket \
            spotify_bracket \
            front_app_bracket \
    --set center_bracket \
            background.height=$CENTER_OUTER_HEIGHT \
            background.corner_radius=$CENTER_DEFAULT_RADIUS \
            background.padding_right=10 \
            background.padding_left=10 \
            background.color=$COLOR_SPOTIFY_BG \
    --add bracket workspace workspaces_spacer_1 workspaces_spacer_2 \
    --set workspace \
            background.padding_right=20 \
            background.padding_left=20 \
            background.height=$CENTER_HEIGHT \
            background.corner_radius=$CENTER_RADIUS \
            background.color=$COLOR_SPACES_BRACKET

# Workspace brackets

for ID in "${MONITOR_WORKSPACES[@]}"
do
  $BAR_NAME \
    --set workspaces."$ID" \
            icon.padding_left=9 \
            icon.padding_right=11 \
            background.height=$CENTER_HEIGHT \
            background.corner_radius=$CENTER_RADIUS \
    --add bracket workspace."$ID" \
            workspaces."$ID" \
            workspaces."$ID".windows \
    --set workspace."$ID" \
            background.height=$CENTER_HEIGHT \
            background.corner_radius=$CENTER_RADIUS \
            background.color=$COLOR_SPACE_BG
done

# RIGHT SECTION

clock=(
    icon.drawing=no
    update_freq=10
    background.padding_right=10
    background.padding_left=10
    script="$PLUGIN_SHARED_DIR/time.sh"
)

clock_icon=(
    icon=$ICON_CLOCK
    icon.color=$COLOR_CLOCK
    # Some numbers seems to get cut at the end, so we add some padding
    label.padding_right=1
    background.padding_right=10
    background.padding_left=0
)

date=(
    label.color=$COLOR_DATE_TEXT
    background.padding_right=20
    background.padding_left=10
    icon.drawing=no
    update_freq=120
    script="$PLUGIN_SHARED_DIR/date.sh"
)

volume=(
    icon=$ICON_VOLUME
    icon.color=$COLOR_STATS
    icon.padding_right=5
    icon.padding_left=5
    background.padding_right=10
    background.padding_left=10
    label.color=$COLOR_STATS
    label.padding_right=5
    #drawing=false
    label.drawing=false
    script="$PLUGIN_SHARED_DIR/volume.sh"
)

airpods=(
    drawing=false
    update_freq=5
    icon.font="$FONT_FACE:Medium:16.0"
    icon.color=$COLOR_STATS
    icon.padding_right=5
    background.padding_right=10
    background.padding_left=5
    label.color=$COLOR_STATS
    script="$PLUGIN_SHARED_DIR/airpods.sh"
)

airpods_case=(
    drawing=false
    update_freq=5
    icon.font="$FONT_FACE:Medium:21.0"
    icon.color=$COLOR_STATS
    icon.padding_right=5
    background.padding_right=10
    background.padding_left=0
    label.color=$COLOR_STATS
    script="$PLUGIN_SHARED_DIR/airpods_case.sh"
)

## Render bar section

$BAR_NAME \
    --add item clock_icon right \
    --set clock_icon "${clock_icon[@]}" \
    --add item clock right \
    --set clock "${clock[@]}" \
    --add item date right \
    --set date "${date[@]}" \
    --add item airpods_case right \
    --set airpods_case "${airpods_case[@]}" \
    --add item airpods right \
    --set airpods "${airpods[@]}" \
    --add item volume right \
    --set volume "${volume[@]}" \
    --subscribe volume volume_change \
    --add item separator_right right \
    --add bracket right_bracket \
            airpods_case \
            airpods \
            volume \
            clock_icon \
            clock \
            date \
            separator_right \
    --set right_bracket \
            background.height=$OUTER_HEIGHT \
            background.corner_radius=$DEFAULT_RADIUS \
            background.padding_right=10 \
            background.padding_left=10 \
            background.color=$COLOR_RIGHT_AREA_BG \
    --add bracket date_bracket \
            airpods_case \
            airpods \
            volume \
            date \
    --set date_bracket \
            background.height=$INNER_HEIGHT \
            background.corner_radius=$INNER_RADIUS \
            background.padding_right=10 \
            background.padding_left=10 \
            background.color=$COLOR_DATE_BG \
    --add bracket utils_right \
            airpods_case \
            airpods \
            volume \
    --set utils_right \
            background.height=$INNER_HEIGHT \
            background.corner_radius=$INNER_RADIUS \
            background.padding_right=20 \
            background.padding_left=10 \
            background.color=$COLOR_UTILS_RIGHT_BG

# INIT 

$BAR_NAME --update
$BAR_NAME --trigger volume_change
$BAR_NAME --trigger aerospace_workspace_reload 

# Quick toggle play pause in order to update now playing
#osascript -e 'tell application "Spotify" to playpause'
#osascript -e 'tell application "Spotify" to playpause'