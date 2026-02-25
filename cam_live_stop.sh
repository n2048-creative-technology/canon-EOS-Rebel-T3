#!/usr/bin/env bash
set -euo pipefail
killall gvfsd-gphoto2 gvfs-gphoto2-volume-monitor 2>/dev/null || true
gphoto2 --set-config viewfinder=0 >/dev/null 2>&1 || true
echo "Live view disabled."

