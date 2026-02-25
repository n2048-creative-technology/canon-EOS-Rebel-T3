#!/usr/bin/env bash
set -euo pipefail

# Usage:
#   cam_timelapse.sh <interval_seconds> <frames> [outdir]
# Examples:
#   cam_timelapse.sh 2 300
#   cam_timelapse.sh 10 360 ~/Pictures/timelapse_sunset

INTERVAL="${1:?Interval seconds required (e.g. 2)}"
FRAMES="${2:?Frame count required (e.g. 300)}"
OUTDIR="${3:-$HOME/Pictures/canon_timelapse_$(date +%Y%m%d_%H%M%S)}"

mkdir -p "$OUTDIR"

killall gvfsd-gphoto2 gvfs-gphoto2-volume-monitor 2>/dev/null || true
gphoto2 --set-config /main/settings/capturetarget=0 >/dev/null 2>&1 || true

echo "Timelapse starting"
echo "Interval: ${INTERVAL}s"
echo "Frames:   ${FRAMES}"
echo "Output:   ${OUTDIR}"
echo "Stop anytime with Ctrl+C"
echo

gphoto2 \
  --capture-image-and-download \
  --force-overwrite \
  --interval "$INTERVAL" \
  --frames "$FRAMES" \
  --filename "$OUTDIR/frame_%Y%m%d_%H%M%S_%n.jpg"

echo "Done."
