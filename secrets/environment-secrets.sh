#!/bin/zsh
# Publishes secrets from the login keychain into the GUI login session, so that
# GUI-launched processes (Orca.app, agent harnesses started from Dock/Finder)
# inherit them as environment variables.
#
# Source of truth: secrets.conf, alongside this script. That file lists service
# names only — no secret material — and is safe to commit.
#
# Run at login via ~/Library/LaunchAgents/com.marcusklingberg.environment-secrets.plist
#
# Register or rotate an item: ./register-secret.sh
#
# Apply without logging out:
#   launchctl kickstart -k gui/$(id -u)/com.marcusklingberg.environment-secrets
# Already-running processes keep their old environment — restart them to pick up changes.

set -u

ACCOUNT="$USER"
SCRIPT_DIR="${0:A:h}"

if [ ! -r "$SCRIPT_DIR/secrets.conf" ]; then
  echo "environment-secrets: $SCRIPT_DIR/secrets.conf not found" >&2
  exit 1
fi
source "$SCRIPT_DIR/secrets.conf"

log() { echo "$(date '+%Y-%m-%d %H:%M:%S') environment-secrets: $*"; }

published=0
missing=0

for entry in "${SECRETS[@]}"; do
  service="${entry%%|*}"
  vars="${entry#*|}"

  # Never fail the whole run on one bad item: a missing LaunchDarkly token must
  # not stop the Azure DevOps PAT from being published.
  value="$(/usr/bin/security find-generic-password -s "$service" -a "$ACCOUNT" -w 2>/dev/null || true)"

  if [ -z "${value:-}" ]; then
    log "SKIP $service — keychain item not readable (missing, or access not granted)"
    missing=$((missing + 1))
    continue
  fi

  for var in ${=vars}; do
    /bin/launchctl setenv "$var" "$value"
    log "published $var from $service (${#value} chars)"
  done
  published=$((published + 1))
done

log "done — $published service(s) published, $missing missing"

# Non-zero only when nothing at all could be published, so launchd surfaces a
# total failure while tolerating partial configuration.
[ "$published" -gt 0 ] || exit 1
