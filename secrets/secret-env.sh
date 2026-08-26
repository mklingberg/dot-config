#!/bin/sh
# Resolves the keychain-backed variables in secrets.conf into the *current*
# process, for anything the login publisher missed.
#
# Why this exists: environment-secrets.sh publishes with `launchctl setenv`,
# which only reaches processes started afterwards. At login Orca.app frequently
# wins that race by a few seconds, and then lives for days — so every terminal
# and agent it spawns inherits an environment with no PAT in it, while
# `launchctl getenv AZURE_DEVOPS_PAT` happily reports a value. This script
# closes that gap by reading the keychain directly.
#
# Sourced from ~/.config/zsh/zprofile, so login shells are covered without
# anyone thinking about it. Agent skills call it explicitly for the cases that
# never went through a login shell.
#
# Usage:
#   . ~/.config/secrets/secret-env.sh   # defines the functions below
#   secret_env                          # fill every empty var in the registry
#   secret_env AZURE_DEVOPS_PAT ...     # fill only these
#
# Sourcing has no side effects — it only defines functions. To print a single
# value from a non-shell context, use the `secret-env` wrapper next to this file.
#
# Existing non-empty values always win: an explicitly exported override is
# never clobbered by the keychain.

secret_env_registry_file() {
  # ${0:A:h} is zsh-only and $0 is unreliable when sourced, so resolve against
  # the fixed location instead of the script path.
  echo "${SECRET_ENV_DIR:-$HOME/.config/secrets}/secrets.conf"
}

# secret_env_service_for VAR -> prints the keychain service feeding VAR
secret_env_service_for() {
  _sev_want="$1"
  _sev_conf="$(secret_env_registry_file)"
  [ -r "$_sev_conf" ] || return 1
  # Parse the SECRETS=( "service|VAR VAR" ) block textually: sourcing it needs
  # array syntax that /bin/sh does not have, and this file must work in sh,
  # bash and zsh alike.
  sed -n 's/^[[:space:]]*"\(.*\)"[[:space:]]*$/\1/p' "$_sev_conf" | while IFS= read -r _sev_entry; do
    _sev_service="${_sev_entry%%|*}"
    _sev_vars="${_sev_entry#*|}"
    # Membership by pattern, not a `for` over $_sev_vars: zsh does not word-split
    # unquoted parameter expansions, so a loop here would silently see
    # "ORCA_AZURE_DEVOPS_TOKEN AZURE_DEVOPS_PAT" as one name.
    case " $_sev_vars " in
      *" $_sev_want "*) echo "$_sev_service"; return 0 ;;
    esac
  done | head -1
}

# secret_env_value VAR -> prints the keychain value feeding VAR, or nothing
secret_env_value() {
  _sev_svc="$(secret_env_service_for "$1")"
  [ -n "$_sev_svc" ] || return 1
  /usr/bin/security find-generic-password -s "$_sev_svc" -a "$USER" -w 2>/dev/null
}

# secret_env [VAR ...] -> export each named (or every registered) var when empty
secret_env() {
  _sev_names="$*"
  if [ -z "$_sev_names" ]; then
    _sev_names="$(sed -n 's/^[[:space:]]*"[^|]*|\(.*\)"[[:space:]]*$/\1/p' "$(secret_env_registry_file)" 2>/dev/null)"
  fi

  # Split via command substitution: it is the one expansion zsh field-splits
  # unquoted, so this iterates names in sh, bash and zsh alike.
  for _sev_name in $(printf '%s\n' "$_sev_names"); do
    # Skip anything already populated — by the publisher, or by hand.
    eval "_sev_current=\${$_sev_name:-}"
    [ -n "$_sev_current" ] && continue

    _sev_val="$(secret_env_value "$_sev_name" || true)"
    if [ -n "$_sev_val" ]; then
      export "$_sev_name=$_sev_val"
    else
      # Never fail a login shell over one missing item, and never print the
      # name of a var some caller merely asked about speculatively.
      [ -n "${SECRET_ENV_VERBOSE:-}" ] && \
        echo "secret-env: no keychain value for $_sev_name" >&2
    fi
  done
  unset _sev_current _sev_val _sev_name _sev_names
  return 0
}
