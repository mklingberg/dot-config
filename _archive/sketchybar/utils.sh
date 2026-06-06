#!/bin/bash

get_display_type() {
    local CURRENT_DISPLAY_NUMBER=$1
    DISPLAY_INFO=$(system_profiler SPDisplaysDataType)
    DISPLAY_COUNT=$(echo "$DISPLAY_INFO" | grep -c 'Resolution') 

    # Initialize variables
    INDEX=0
    DISPLAY_INDEX_INTERNAL=""
    IN_DISPLAYS_BLOCK=0

    # Loop through each line of the output
    while IFS= read -r LINE; do
        # Check if we've entered the Displays block
        if [[ $LINE == *"Displays:"* ]]; then
            IN_DISPLAYS_BLOCK=1
        fi

        # Only process lines if inside the Displays block
        if [[ $IN_DISPLAYS_BLOCK -eq 1 ]]; then
            # Check if the line contains the name of a display (first indentation)
            if [[ $LINE =~ ^[[:space:]]{8}[^[:space:]].*: ]]; then
                ((INDEX++))  # Increment index for each new display
            fi

            # Check if the line contains "Connection Type: Internal"
            if [[ $LINE == *"Connection Type: Internal"* ]]; then
                DISPLAY_INDEX_INTERNAL=$INDEX
                break  # Exit the loop once the internal display is found
            fi
        fi
    done <<< "$DISPLAY_INFO"

    if [[ $DISPLAY_COUNT -eq 3 && $DISPLAY_INDEX_INTERNAL != "" ]] ; then
         # With 3 displays, the internal display seems to get index 2 with system profiler but 3 with sketchybar?!
        DISPLAY_INDEX_INTERNAL=$((DISPLAY_INDEX_INTERNAL + 1))
    fi

    if [[ $CURRENT_DISPLAY_NUMBER -eq $DISPLAY_INDEX_INTERNAL ]]; then
        echo "Built-in"
    else
        echo "External"
    fi
}

MONITOR_INFO=$(aerospace list-monitors --format "%{monitor-id}|%{monitor-appkit-nsscreen-screens-id}|%{monitor-name}" | awk -v display="$DISPLAY_NUMBER" -F'|' '$2 == display')
MONITOR_ID=$(echo "$MONITOR_INFO" | awk -F'|' '{print $1}')
MONITOR_NAME=$(echo "$MONITOR_INFO" | awk -F'|' '{print $3}')
MONITOR_INTERNAL=false

if [[ $MONITOR_NAME == *"Built-in"* ]]; then
    MONITOR_INTERNAL=true
fi

export MONITOR_ID
export MONITOR_NAME
export MONITOR_INTERNAL

fade_color() {
    local original_color=$1
    local transparency=${2:-99}  # Default if $2 is not specified
    local faded_color="0x${transparency}${original_color:4}"
    echo $faded_color
}