#!/bin/bash
# Smart horizontal move (hyper-shift-h/l).
#   In a row, neighbour is a plain window -> join-with (stack the two)
#   In a row, neighbour is in a stack     -> move (enter the stack; join-with would wrap it, AeroSpace #1485)
#   In a row, at the edge                 -> move, stop (don't wrap the rest of the row)
#   In a stack                            -> move out; at the edge, split off to that side (implicit container)
# Peeks at the neighbour by focusing it and back: a brief focus flicker.
set -u
dir=${1:?left|right}
as=/opt/homebrew/bin/aerospace

move() { "$as" move "$dir" --boundaries all-monitors-outer-frame --boundaries-action "${1:-stop}"; }

read -r me layout <<<"$("$as" list-windows --focused --format '%{window-id} %{window-layout}')"
case $layout in
    h_*) ;;
    v_*) move create-implicit-container; exit ;;
    *) move; exit ;;
esac

"$as" focus "$dir" --ignore-floating --boundaries workspace --boundaries-action fail 2>/dev/null || { move; exit; }
neighbour_layout=$("$as" list-windows --focused --format '%{window-layout}')
"$as" focus --window-id "$me"

if [[ $neighbour_layout == h_* ]]; then
    "$as" join-with "$dir"
else
    move
fi
