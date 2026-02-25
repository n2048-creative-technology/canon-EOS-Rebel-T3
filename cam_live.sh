#!/usr/bin/env bash
set -euo pipefail

# Live view, lowest practical latency, maximum available resolution (Large)

killall gvfsd-gphoto2 gvfs-gphoto2-volume-monitor 2>/dev/null || true

# Force largest liveview size (your camera choices: 0 Large, 1 Medium)
gphoto2 --set-config /main/capturesettings/liveviewsize=0 >/dev/null

# Enable live view
gphoto2 --set-config /main/actions/viewfinder=1 >/dev/null || gphoto2 --set-config viewfinder=1 >/dev/null

# Stream MJPEG and make ffplay buffer as little as possible
exec gphoto2 --capture-movie --stdout \
  | ffplay -fflags nobuffer -flags low_delay -framedrop -probesize 32 -analyzeduration 0 -sync ext -

