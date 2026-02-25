#!/usr/bin/env bash
set -euo pipefail

# Timelapse capture to SD card (no download).
#
# Usage:
#   cam_timelapse_to_sd.sh <interval_seconds> <frames>
#
# Examples:
#   cam_timelapse_to_sd.sh 5 120
#   cam_timelapse_to_sd.sh 2 300

INTERVAL="${1:?Interval seconds required (e.g. 5)}"
FRAMES="${2:?Frame count required (e.g. 120)}"

killall gvfsd-gphoto2 gvfs-gphoto2-volume-monitor 2>/dev/null || true

CFG="$(gphoto2 --get-config /main/settings/capturetarget 2>/dev/null || true)"
CARD_VAL="$(echo "$CFG" | awk 'BEGIN{IGNORECASE=1} $1=="Choice:" && $0 ~ /card/ {print $2; exit}')"

if [[ -n "${CARD_VAL:-}" ]]; then
  gphoto2 --set-config /main/settings/capturetarget="$CARD_VAL" >/dev/null
else
  gphoto2 --set-config /main/settings/capturetarget=1 >/dev/null 2>&1 || true
fi

echo "Timelapse to SD card"
echo "Interval: ${INTERVAL}s"
echo "Frames:   ${FRAMES}"
echo "Stop anytime with Ctrl+C"
echo

# For SD-only timelapse, use capture-image (no download).
# gphoto2's --interval/--frames works with this on many EOS bodies.
gphoto2 --capture-image --interval "$INTERVAL" --frames "$FRAMES"

echo "Done. Images should be on the camera SD card."
