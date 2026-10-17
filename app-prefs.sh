#!/bin/bash
set -euo pipefail

# Sync app settings with this repo. Plists can't be symlinked (cfprefsd replaces
# the link), so settings are exported/imported instead.
#   ./app-prefs.sh export   current settings -> repo, per-machine state stripped
#   ./app-prefs.sh import   repo -> current settings (quits + relaunches running apps)
CONFIG_DIR="$(cd "$(dirname "$0")" && pwd)"

# dir domain app-name [allowlist]
# Without an allowlist everything except VOLATILE is kept.
DEFAULTS_APPS=(
  "tinycast com.tinycast.app Tinycast"
  "vorssaint com.vorssaint.utils Vorssaint"
  # Allowlist keeps the Paddle license key out of git
  "bettermouse com.naotanhaocan.BetterMouse BetterMouse appitems,config,ee,keyboards,logikeys,mice"
)

# Usage stats, window/display state, bookmarks, onboarding/migration flags: per-machine churn
VOLATILE='^(NS|Apple)|Bookmark$|Habit|Usage|LastCheck|LastCount|NotifiedIDs|[Vv]ersion$|Migrated$|Applied$|Onboard|onboarding|Initialized$|Installed$|Rechecked$|PromptState$|^palette(Position|ExpandedCenterDisplays)$|^settingsWindow|^screenshotLast|LastZoom$|^panel(Collapsed|Control)|^shelfItems$'

BTT_PRESET="Default"
BTT_FILE="$CONFIG_DIR/bettertouchtool/$BTT_PRESET.bttpreset"

py() { /usr/bin/python3 -I -c "$@"; }

# Values that are themselves binary plists get decoded for readable diffs;
# their keys are listed under _bplistKeys so import can re-encode them.
export_defaults() {
  local dir="$1" domain="$2" allow="${4:-}"
  mkdir -p "$CONFIG_DIR/$dir"
  defaults export "$domain" - | py '
import plistlib, re, sys
prefs = plistlib.loads(sys.stdin.buffer.read())
volatile, allow = sys.argv[1], [k for k in sys.argv[2].split(",") if k]
keep = {k: v for k, v in prefs.items() if (k in allow if allow else not re.search(volatile, k))}
nested = sorted(k for k, v in keep.items() if isinstance(v, bytes) and v.startswith(b"bplist00"))
for k in nested:
    keep[k] = plistlib.loads(keep[k])
if nested:
    keep["_bplistKeys"] = nested
sys.stdout.buffer.write(plistlib.dumps(keep, sort_keys=True))
' "$VOLATILE" "$allow" > "$CONFIG_DIR/$dir/$domain.plist"
  echo "Exported $domain -> $dir/$domain.plist"
}

import_defaults() {
  local dir="$1" domain="$2" name="$3"
  local src="$CONFIG_DIR/$dir/$domain.plist"
  [ -f "$src" ] || { echo "Skipping $domain (no $dir/$domain.plist)"; return; }

  # A running app would write its in-memory settings back over the import
  local was_running=false
  if pgrep -xq "$name"; then
    was_running=true
    osascript -e "quit app \"$name\""
    while pgrep -xq "$name"; do sleep 0.5; done
  fi

  local merged
  merged="$(mktemp)"
  { defaults export "$domain" - 2>/dev/null || true; } | py '
import plistlib, sys
raw = sys.stdin.buffer.read()
prefs = plistlib.loads(raw) if raw.strip() else {}
with open(sys.argv[1], "rb") as f:
    repo = plistlib.load(f)
for k in repo.pop("_bplistKeys", []):
    repo[k] = plistlib.dumps(repo[k], fmt=plistlib.FMT_BINARY)
prefs.update(repo)
sys.stdout.buffer.write(plistlib.dumps(prefs))
' "$src" > "$merged"
  defaults import "$domain" "$merged"
  rm -f "$merged"
  echo "Imported $dir/$domain.plist -> $domain"

  if $was_running; then open -a "$name"; fi
}

# BetterTouchTool keeps triggers in its own database; its AppleScript preset export/import is the supported route
export_btt() {
  mkdir -p "$(dirname "$BTT_FILE")"
  osascript -e "tell application \"BetterTouchTool\" to export_preset \"$BTT_PRESET\" outputPath \"$BTT_FILE\" compress false includeSettings true" >/dev/null
  echo "Exported BetterTouchTool preset $BTT_PRESET -> bettertouchtool/$BTT_PRESET.bttpreset"
}

import_btt() {
  [ -f "$BTT_FILE" ] || { echo "Skipping BetterTouchTool (no bettertouchtool/$BTT_PRESET.bttpreset)"; return; }
  osascript -e "tell application \"BetterTouchTool\" to import_preset \"$BTT_FILE\"" >/dev/null
  echo "Imported bettertouchtool/$BTT_PRESET.bttpreset -> BetterTouchTool"
}

case "${1:-}" in
  export|import)
    for app in "${DEFAULTS_APPS[@]}"; do
      read -r dir domain name allow <<< "$app"
      "${1}_defaults" "$dir" "$domain" "$name" "${allow:-}"
    done
    "${1}_btt"
    ;;
  *)
    echo "Usage: $0 export|import" >&2
    exit 1
    ;;
esac
