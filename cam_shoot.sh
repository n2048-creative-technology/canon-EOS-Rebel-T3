#!/usr/bin/env bash
set -euo pipefail

# Usage:
#   cam_shoot.sh [count] [outdir]
# Examples:
#   cam_shoot.sh
#   cam_shoot.sh 5
#   cam_shoot.sh 20 ~/Pictures/shoots

COUNT="${1:-1}"
OUTDIR="${2:-$HOME/Pictures/canon_shoot_$(date +%Y%m%d_%H%M%S)}"

mkdir -p "$OUTDIR"

# Stop GNOME from claiming the camera
killall gvfsd-gphoto2 gvfs-gphoto2-volume-monitor 2>/dev/null || true

# Prefer capture-to-host workflow
gphoto2 --set-config /main/settings/capturetarget=0 >/dev/null 2>&1 || true

echo "Saving to: $OUTDIR"
echo "Taking $COUNT photo(s)..."

for ((i=1; i<=COUNT; i++)); do
  fname="img_$(date +%Y%m%d_%H%M%S)_$(printf "%03d" "$i").jpg"
  gphoto2 --capture-image-and-download --force-overwrite --filename "$OUTDIR/$fname"
  echo "Saved: $OUTDIR/$fname"
done

echo "Done."
