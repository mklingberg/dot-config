#!/bin/bash

# docker_memory.sh
# Get the memory usage percentage across all Docker containers

# Get the docker stats for all containers
DOCKER_STATS_MEM=$(docker stats --no-stream --format "{{.MemPerc}}")

# Check if DOCKER_STATS_MEM is empty
if [ -z "$DOCKER_STATS_MEM" ]; then
    # Hide the item if no stats are returned, then docker isnt running
    $BAR_NAME --set $NAME drawing=false
    exit 0
fi

# Initialize total memory usage percentage
TOTAL_MEMORY_PERCENT=0
LABEL_THRESHOLD=50
SHOW_LABEL=false

# Sum up the memory usage percentages
while read -r MEM_PERCENT; do
    # Remove the '%' sign and convert to float
    MEM_PERCENT=${MEM_PERCENT%\%}
    TOTAL_MEMORY_PERCENT=$(echo "$TOTAL_MEMORY_PERCENT + $MEM_PERCENT" | bc)
done <<< "$DOCKER_STATS_MEM"

# Round up the total memory usage percentage to the nearest integer
TOTAL_MEMORY_PERCENT=$(echo "$TOTAL_MEMORY_PERCENT" | awk '{print int($1+0.999)}')

if [ $TOTAL_MEMORY_PERCENT -gt $LABEL_THRESHOLD ]; then
  SHOW_LABEL=true
fi

# Set the memory usage percentage in SketchyBar
$BAR_NAME --set $NAME drawing=$SHOW_LABEL label="${TOTAL_MEMORY_PERCENT}%"