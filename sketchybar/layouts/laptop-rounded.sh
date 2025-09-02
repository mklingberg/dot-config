#!/bin/bash
source "$HOME/.config/$BAR_NAME/theme.sh"
source "$HOME/.config/sketchybar/plugins/aerospace_windows.sh" $MONITOR_ID

PLUGIN_DIR="$HOME/.config/sketchybar/plugins-laptop"
PLUGIN_SHARED_DIR="$HOME/.config/sketchybar/plugins"
ITEM_DIR="$CONFIG_DIR/items"
SPOTIFY_EVENT="com.spotify.client.PlaybackStateChanged"

MARGIN_LEFT=0
MARGIN_RIGHT=0
BAR_HEIGHT=46
SEPARATOR_WIDTH=5

DEFAULT_RADIUS=16
INNER_RADIUS=14

OUTER_HEIGHT=32
INNER_HEIGHT=28

FRONT_APP_ICON_SIZE=16
FRONT_APP_NAME_SIZE=16

bar=(
    height=$BAR_HEIGHT
    color=$TRANSPARENT
    margin=0
    #sticky=on
    padding_left=8
    padding_right=8
    notch_width=234
    display=$DISPLAY_NUMBER
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

# Left area

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

## Utils

cpu_user=(
    icon=$ICON_CPU_IDLE
    icon.color=$COLOR_STATS
    icon.padding_right=5
    icon.padding_left=5
    label.color=$COLOR_STATS
    background.padding_left=10
    background.padding_right=5
    script="$PLUGIN_SHARED_DIR/cpu_load.sh"
)

battery=(
    update_freq=60
    icon.padding_right=5
    icon.padding_left=0
    background.padding_left=0
    background.padding_right=10
    script="$PLUGIN_DIR/battery.sh"
)

brew=(
    icon=$ICON_BREW
    update_freq=120
    icon.padding_left=10
    icon.padding_right=10
    label.padding_right=10
    label.drawing=off
    background.height=$INNER_HEIGHT
    background.corner_radius=$DEFAULT_RADIUS
    background.color=$COLOR_BREW_BG
    script="$PLUGIN_SHARED_DIR/brew.sh"
)

$BAR_NAME \
    --add item screen left \
    --set screen "${screen[@]}" \
    --subscribe screen mouse.clicked mouse.entered mouse.exited \
    --add item cpu_user left \
    --set cpu_user "${cpu_user[@]}" \
    --add item battery left \
    --set battery "${battery[@]}" \
    --add event brew_update \
    --add item brew left \
    --set brew "${brew[@]}" \
    --subscribe brew brew_update mouse.clicked \
    --add item separator_utils_1 left

# Render Aerospace workspaces
$BAR_NAME \
    --add event aerospace_workspace_change \
    --add event aerospace_workspace_reload \
    --add event aerospace_window_moved \
    --add item  workspaces_spacer_1 left \
    --set       workspaces_spacer_1 \
                width=20 \
                label.drawing=off

# Fetch workspaces visible on this display/monitor
MONITOR_WORKSPACES=( $(aerospace list-workspaces --monitor $MONITOR_ID) )
ADD_SPACER=false
SHOW_APPS=off

# If there are less than 5 workspaces show apps 
# (shows apps with secondary monitory attached)
if [ ${#MONITOR_WORKSPACES[@]} -lt 5 ]; then
    SHOW_APPS=on
fi

for ID in ${MONITOR_WORKSPACES[@]}; do
    # Only add spacer between workspaces
    if [ "$ADD_SPACER" = true ]; then
        $BAR_NAME \
            --add item  workspace_spacer_"$ID" left \
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
        label=" —"
        label.y_offset=-1
        label.drawing=$SHOW_APPS
        label.padding_left=0
        label.padding_right=20
        script="$PLUGIN_SHARED_DIR/aerospace_focus.sh $ID $MONITOR_ID"
    )
    
    $BAR_NAME \
        --add item  workspaces."$ID" left \
        --set       workspaces."$ID" "${workspace_no[@]}" \
        --add item  workspaces."$ID".windows left \
        --subscribe workspaces."$ID".windows aerospace_workspace_change \
        --set       workspaces."$ID".windows "${workspace_windows[@]}"

    ADD_SPACER=true   
done

$BAR_NAME \
    --add item  workspaces_spacer_2 left \
    --subscribe workspaces_spacer_2 aerospace_workspace_change aerospace_workspace_reload \
    --set       workspaces_spacer_2 \
                script="$PLUGIN_SHARED_DIR/aerospace_windows.sh $MONITOR_ID" \
                width=24 \
                drawing=on \
                label.drawing=off

$BAR_NAME \
    --add item separator_spaces left \
    --add bracket left_bracket \
            screen \
            cpu_user \
            brew \
            /workspaces\.*/ \
            separator_spaces \
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
            background.color=$COLOR_UTILS_BG \
    --add bracket workspace brew /workspaces\.*/ \
    --set workspace \
            background.height=$INNER_HEIGHT \
            background.corner_radius=$INNER_RADIUS \
            background.color=$COLOR_SPACES_BRACKET

for ID in "${MONITOR_WORKSPACES[@]}"
do
  $BAR_NAME \
    --set workspaces."$ID" \
            icon.padding_left=12 \
            icon.padding_right=13 \
            background.height=$INNER_HEIGHT \
            background.corner_radius=$INNER_RADIUS \
    --add bracket workspace."$ID" \
            workspaces."$ID" \
            workspaces."$ID".windows \
    --set workspace."$ID" \
            background.height=$INNER_HEIGHT \
            background.corner_radius=$INNER_RADIUS \
            background.color=$COLOR_SPACE_BG
done

# Right area

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
    background.padding_right=10
    background.padding_left=0
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

spotify=(
    icon=$ICON_SPOTIFY
    label.drawing=off
    label.padding_left=10
    background.padding_left=12
    background.padding_right=12
    script="$PLUGIN_DIR/spotify.sh"
)

$BAR_NAME \
    --add item clock_icon right \
    --set clock_icon "${clock_icon[@]}" \
    --add item clock right \
    --set clock "${clock[@]}" \
    --add item airpods_case right \
    --set airpods_case "${airpods_case[@]}" \
    --add item airpods right \
    --set airpods "${airpods[@]}" \
    --add item volume right \
    --set volume "${volume[@]}" \
    --subscribe volume volume_change \
    --add item separator_right right \
    --add event spotify_change $SPOTIFY_EVENT \
    --add item spotify right \
    --set spotify "${spotify[@]}" \
    --subscribe spotify spotify_change mouse.clicked \
    --add item separator_spotify right \
    --add bracket right_bracket \
            airpods_case \
            airpods \
            volume \
            clock_icon \
            clock \
            separator_right \
            spotify \
            separator_spotify \
    --set right_bracket \
            background.height=$OUTER_HEIGHT \
            background.corner_radius=$DEFAULT_RADIUS \
            background.padding_right=10 \
            background.padding_left=10 \
            background.color=$COLOR_RIGHT_AREA_BG \
    --add bracket spotify_bracket \
            airpods_case \
            airpods \
            volume \
            spotify \
    --set spotify_bracket \
            background.height=$INNER_HEIGHT \
            background.corner_radius=$INNER_RADIUS \
            background.padding_right=10 \
            background.padding_left=10 \
            background.color=$COLOR_SPOTIFY_BG \
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
osascript -e 'tell application "Spotify" to playpause'
osascript -e 'tell application "Spotify" to playpause'