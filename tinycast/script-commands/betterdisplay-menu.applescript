#!/usr/bin/osascript

# @raycast.schemaVersion 1
# @raycast.title BetterDisplay Menu
# @raycast.mode silent
# @raycast.packageName BetterDisplay
# @raycast.description Open the BetterDisplay menu (works with the menu bar icon hidden)

-- Menu bar icon is hidden, so go via Settings' unlabelled "App Menu" button
-- (first of the three bottom-left sidebar buttons). Breaks if BetterDisplay reshuffles Settings.
do shell script "open -a BetterDisplay"
tell application "System Events" to tell process "BetterDisplay"
	repeat 50 times
		repeat with w in windows
			if subrole of w is "AXStandardWindow" and (count of UI elements of group 1 of w) >= 11 then
				click UI element 11 of group 1 of w
				return
			end if
		end repeat
		delay 0.1
	end repeat
end tell
error "BetterDisplay Settings window not found"
