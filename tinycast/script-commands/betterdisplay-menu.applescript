#!/usr/bin/osascript

# @raycast.schemaVersion 1
# @raycast.title BetterDisplay Menu
# @raycast.mode silent
# @raycast.packageName BetterDisplay
# @raycast.description Open the BetterDisplay menu bar dropdown

tell application "System Events" to tell process "BetterDisplay"
	click menu bar item 1 of menu bar 2
end tell
