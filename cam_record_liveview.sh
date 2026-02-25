#!/usr/bin/env bash
set -euo pipefail

# Record Canon Live View (MJPEG over USB) to laptop.
#
# Usage:
#   cam_record_liveview.sh [outfile.mp4] [duration_seconds] [mode]
#
# mode:
#   fast  -> very low CPU, larger files, good for realtime workflows
#   hq    -> better quality per size, more CPU
#
# Examples:
#   cam_record_liveview.sh
#   cam_record_liveview.sh ./test.mp4 10 fast
#   cam_record_liveview.sh ~/Videos/live.mp4 60 hq

OUTFILE="${1:-$HOME/Videos/canon_liveview_$(date +%Y%m%d_%H%M%S).mp4}"
DURATION="${2:-}"     # optional
MODE="${3:-fast}"     # fast|hq

mkdir -p "$(dirname "$OUTFILE")"

# Release camera from GNOME/GVFS
killall gvfsd-gphoto2 gvfs-gphoto2-volume-monitor 2>/dev/null || true

# Max live view size on your camera: 0 Large, 1 Medium
gphoto2 --set-config /main/capturesettings/liveviewsize=0 >/dev/null 2>&1 || true

# Enable live view
gphoto2 --set-config /main/actions/viewfinder=1 >/dev/null 2>&1 || gphoto2 --set-config viewfinder=1 >/dev/null 2>&1

echo "Recording Live View to: $OUTFILE"
if [[ -n "$DURATION" ]]; then
  echo "Duration: ${DURATION}s"
else
  echo "Duration: until Ctrl+C"
fi
echo "Mode: $MODE"

FFMPEG_T=()
if [[ -n "$DURATION" ]]; then
  FFMPEG_T=(-t "$DURATION")
fi

# Encoder settings
# - We keep the range conversion to avoid the MJPEG pixel format warning and to normalize levels.
if [[ "$MODE" == "hq" ]]; then
  # Higher quality per bitrate; more CPU
  VOPTS=(-c:v libx264 -preset veryfast -crf 20)
else
  # Lowest CPU / lowest latency; larger files
  VOPTS=(-c:v libx264 -preset ultrafast -tune zerolatency -crf 23)
fi

gphoto2 --capture-movie --stdout \
| ffmpeg -hide_banner -loglevel error \
    -color_range pc -f mjpeg -i - \
    "${FFMPEG_T[@]}" \
    -vf "format=yuv420p,scale=out_range=tv" \
    "${VOPTS[@]}" \
    -color_range tv \
    -movflags +faststart \
    "$OUTFILE"

echo "Done."
