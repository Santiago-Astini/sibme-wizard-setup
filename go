#!/usr/bin/env bash
# Sibme Wizard starter (public; holds no secrets). It asks for the Sibme Wizard key, downloads the real setup from
# the PRIVATE plugin repo with it, and runs that setup. The key is never shown, never saved by this script, and is
# passed to curl through a private temporary file (not on the command line).
#   Everyone:                curl -fsSL https://raw.githubusercontent.com/Santiago-Astini/sibme-wizard-setup/main/go | bash
#   The owner's test copy:   curl -fsSL https://raw.githubusercontent.com/Santiago-Astini/sibme-wizard-setup/main/go | bash -s staging
# Source: package/plugin/go in the Sibme Wizard source repo (copied here by hand on each change).

REPO_PATH="Santiago-Astini/sibme-wizard-plugin"
CHANNEL="${1:-main}"
case "$CHANNEL" in
  main) URL="https://api.github.com/repos/$REPO_PATH/contents/setup.sh" ;;
  staging) URL="https://api.github.com/repos/$REPO_PATH/contents/setup.sh?ref=staging" ;;
  *) echo "Unknown channel: $CHANNEL (use nothing, or: staging)"; exit 1 ;;
esac

# Piped into bash, this script's input is the download itself: questions must read from the keyboard (/dev/tty).
if [ ! -r /dev/tty ]; then
  echo "Please run this in a terminal window (Mac: Terminal; Windows: Git Bash)."; exit 1
fi
printf 'Sibme Wizard key (hidden): '
IFS= read -rs K < /dev/tty
printf '\n'
[ -n "$K" ] || { echo "No key typed. Ask the Wizard owner for the key, then run this again."; exit 1; }

d="$(mktemp -d)" || exit 1
trap 'rm -rf "$d"' EXIT
umask 077
printf 'Authorization: Bearer %s\n' "$K" > "$d/h"
if ! curl -fsL -H @"$d/h" -H "Accept: application/vnd.github.raw" -o "$d/setup.sh" "$URL"; then
  echo "Could not download the setup. Check the key (or ask the Wizard owner for a new one) and your internet."
  exit 1
fi
rm -f "$d/h"
SIBME_KEY="$K" bash "$d/setup.sh" < /dev/tty
