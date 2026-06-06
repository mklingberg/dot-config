#!/bin/bash
MONITOR_ID=$1

source "$HOME/.config/sketchybar/plugins/icon_map_fn.sh"

function update_workspace_windows() {
    WORKSPACE_ID=$1
    WINDOWS=$2

    # Filter on both monitor and workspace id
    APPS=$(echo "$WINDOWS" | awk -v monitor="$MONITOR_ID" -v ws="$WORKSPACE_ID" -F'|' '$1 == monitor && $2 == ws {print $2 "|" $3}')
    ICON_STRIP=""

    while IFS='|' read -r ID APP_NAME;
    do
        if [ -n "$APP_NAME" ]; then
            ICON_STRIP+=" $(icon_map "$APP_NAME")"
        fi
    done <<< "${APPS}"

    if [ -n "$ICON_STRIP" ]; then
        $BAR_NAME \
            --set workspaces.$WORKSPACE_ID.windows \
                label=" $ICON_STRIP"
    else 
        $BAR_NAME \
            --set workspaces.$WORKSPACE_ID.windows \
                label=" —"
    fi
}

function update_monitor_windows() {
    WINDOWS=$(aerospace list-windows --monitor "$MONITOR_ID" --format "%{monitor-id}|%{workspace}|%{app-name}")
    for WORKSPACE_ID in $(aerospace list-workspaces --monitor "$MONITOR_ID"); do
        update_workspace_windows "$WORKSPACE_ID" "$WINDOWS"
    done
}

function init_monitor_windows() {
    update_monitor_windows
    init_focused
}

function init_focused() {
    FOCUSED_WORKSPACE=$(aerospace list-workspaces --monitor "$MONITOR_ID" --visible)
    # Trigger event to force init of focused workspace
    $BAR_NAME --trigger aerospace_workspace_change FOCUSED_WORKSPACE="$FOCUSED_WORKSPACE" FOCUSED_MONITOR="$MONITOR_ID"
}

if [ "$SENDER" = "aerospace_window_moved" ]; then
    echo "Window moved"
    # As we dont know where the window was moved, we refresh all workspaces
    update_monitor_windows
fi

if [ "$SENDER" = "aerospace_workspace_reload" ]; then
    init_monitor_windows
    echo "Workspace reloaded"
fi

if [ "$SENDER" = "aerospace_workspace_change" ]; then
    update_monitor_windows
fi
