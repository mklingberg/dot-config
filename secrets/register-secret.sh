#!/bin/zsh
# Interactive registration / rotation of the login-keychain items listed in
# secrets.conf. The token is never passed as an argument, so it never reaches
# shell history or the process table.
#
#   ./register-secret.sh                  # pick from a status list
#   ./register-secret.sh <service>        # register or rotate one directly

set -u

ACCOUNT="$USER"
SCRIPT_DIR="${0:A:h}"

if [ ! -r "$SCRIPT_DIR/secrets.conf" ]; then
  echo "register-secret: $SCRIPT_DIR/secrets.conf not found" >&2
  exit 1
fi
source "$SCRIPT_DIR/secrets.conf"

service_registered() {
  /usr/bin/security find-generic-password -s "$1" -a "$ACCOUNT" -w >/dev/null 2>&1
}

vars_for() {
  local entry
  for entry in "${SECRETS[@]}"; do
    [ "${entry%%|*}" = "$1" ] && { echo "${entry#*|}"; return 0; }
  done
  return 1
}

register() {
  local service="$1" vars
  vars="$(vars_for "$service")" || {
    echo "register-secret: '$service' is not in secrets.conf" >&2
    echo "Add it there first, so the publisher knows which variables it feeds." >&2
    exit 1
  }

  echo "Service : $service"
  echo "Feeds   : $vars"
  service_registered "$service" && echo "Status  : already registered — this will replace the value"
  echo
  echo "Paste the token, press Return, then confirm. Input is hidden."

  # -U replaces an existing item; -w with no value prompts twice, hidden;
  # -T /usr/bin/security pre-authorises the binary the login publisher uses.
  if ! /usr/bin/security add-generic-password -U \
      -s "$service" -a "$ACCOUNT" -T /usr/bin/security -w; then
    echo "register-secret: failed to store $service" >&2
    exit 1
  fi

  local value
  value="$(/usr/bin/security find-generic-password -s "$service" -a "$ACCOUNT" -w 2>/dev/null || true)"
  if [ -z "${value:-}" ]; then
    echo "register-secret: stored, but cannot read it back — grant access when prompted" >&2
    exit 1
  fi

  echo
  echo "Stored: $service (${#value} chars)"
  echo
  echo "Next: publish it into the login session with"
  echo "  launchctl kickstart -k gui/$(id -u)/$(launchctl list | awk '/environment-secrets/{print $3}')"
  echo "Already-running apps keep their old environment — restart them to pick it up."
}

if [ $# -ge 1 ]; then
  register "$1"
  exit 0
fi

echo "Secrets in secrets.conf:"
echo
typeset -a services
services=()
i=1
for entry in "${SECRETS[@]}"; do
  service="${entry%%|*}"
  services+=("$service")
  if service_registered "$service"; then state="registered"; else state="MISSING"; fi
  printf '  %d) %-28s %-11s → %s\n' "$i" "$service" "$state" "${entry#*|}"
  i=$((i + 1))
done

echo
printf 'Number to register or rotate (Return to cancel): '
read -r choice

[ -z "${choice:-}" ] && { echo "Cancelled."; exit 0; }

if [[ ! "$choice" =~ ^[0-9]+$ ]] || [ "$choice" -lt 1 ] || [ "$choice" -gt "${#services[@]}" ]; then
  echo "register-secret: '$choice' is not one of the listed numbers" >&2
  exit 1
fi

echo
register "${services[$choice]}"
