#!/usr/bin/env bash
set -euo pipefail

# Take still photos and store them on the camera SD card (no download).
#
# Usage:
#   cam_shoot_to_sd.sh [count]
#
# Examples:
#   cam_shoot_to_sd.sh
#   cam_shoot_to_sd.sh 5

COUNT="${1:-1}"

# Release camera from GNOME/GVFS
killall gvfsd-gphoto2 gvfs-gphoto2-volume-monitor 2>/dev/null || true

# Determine which capturetarget choice corresponds to SD card, then set it.
CFG="$(gphoto2 --get-config /main/settings/capturetarget 2>/dev/null || true)"

# Try to find a choice containing "card" (case-insensitive). If found, use its numeric value.
CARD_VAL="$(echo "$CFG" | awk 'BEGIN{IGNORECASE=1} $1=="Choice:" && $0 ~ /card/ {print $2; exit}')"

if [[ -n "${CARD_VAL:-}" ]]; then
  gphoto2 --set-config /main/settings/capturetarget="$CARD_VAL" >/dev/null
else
  # Fallback: many Canon configs use 1 for memory card, but this is not universal.
  # If this fails, run: gphoto2 --get-config /main/settings/capturetarget
  gphoto2 --set-config /main/settings/capturetarget=1 >/dev/null 2>&1 || true
fi

echo "Capturing $COUNT photo(s) to SD card..."

for ((i=1; i<=COUNT; i++)); do
  gphoto2 --capture-image
  echo "Shot $i/$COUNT"
done

echo "Done. Images should be on the camera SD card."

