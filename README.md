
# Canon EOS 1100D (Rebel T3) – gPhoto2 Control Scripts

This folder contains Bash scripts for controlling a Canon EOS 1100D (Rebel T3) using gphoto2 on Ubuntu/Linux.

These scripts allow you to:

- Capture photos directly to your laptop
- Run timelapses with adjustable timing
- Start low-latency Live View streaming
- Stop Live View cleanly

No firmware modifications (e.g. Magic Lantern) are required.

---

# Requirements

Install required packages:

```bash
sudo apt update
sudo apt install gphoto2 ffmpeg
```

Optional (alternative video viewer):

```bash
sudo apt install vlc
```

---

# Prevent GNOME From Grabbing the Camera

GNOME may automatically mount the camera and block gphoto2.

To disable automount permanently:

```bash
gsettings set org.gnome.desktop.media-handling automount false
gsettings set org.gnome.desktop.media-handling automount-open false
```

The scripts also attempt to temporarily stop conflicting services.

---

# Scripts

---

## 1) cam_shoot.sh

Capture one or multiple photos and store them on your laptop.

### Usage

```bash
cam_shoot.sh [count] [output_directory]
```

### Examples

Take one photo (default):

```bash
cam_shoot.sh
```

Take 5 photos:

```bash
cam_shoot.sh 5
```

Take 10 photos and store them in a specific folder:

```bash
cam_shoot.sh 10 ~/Pictures/test_shoot
```

### What It Does

- Stops GNOME camera auto-mount services
- Sets capture target to laptop (avoids SD card delay)
- Saves timestamped images
- Automatically creates output directory

---

## 2) cam_live.sh

Start Live View streaming with:

- Maximum available resolution ("Large")
- Minimum practical latency
- Frame dropping instead of buffering

### Usage

```bash
cam_live.sh
```

### What It Does

- Forces Live View size to "Large"
- Enables Live View
- Streams MJPEG via USB
- Pipes output into ffplay with low-latency flags

### Notes

- USB Live View resolution is limited by camera hardware.
- Minimum achievable latency is typically ~200–400 ms.
- For ultra-low latency, HDMI capture hardware is required.

---

## 3) cam_live_stop.sh

Stop Live View cleanly.

### Usage

```bash
cam_live_stop.sh
```

### What It Does

- Disables Live View
- Prevents camera from remaining in active stream state

Useful if Live View remains active after interrupting cam_live.sh.

---

## 4) cam_timelapse.sh

Run a timelapse with adjustable interval and frame count.

### Usage

```bash
cam_timelapse.sh <interval_seconds> <frames> [output_directory]
```

### Examples

Take 120 frames every 5 seconds:

```bash
cam_timelapse.sh 5 120
```

Take 300 frames every 2 seconds:

```bash
cam_timelapse.sh 2 300
```

Specify output folder:

```bash
cam_timelapse.sh 10 360 ~/Pictures/sunset_timelapse
```

### What It Does

- Stops GNOME auto-mount conflicts
- Sets capture target to laptop
- Uses gphoto2 built-in interval shooting
- Stores images with timestamped filenames
- Automatically creates output folder

---

# Recommended Camera Settings

For stable operation:

- Mode dial: Manual (M)
- Disable autofocus for consistent timelapse
- Disable image review
- Use fully charged battery
- Use short, high-quality USB cable

---

# Example Workflow

Start Live View:

```bash
cam_live.sh
```

Take 20 stills:

```bash
cam_shoot.sh 20
```

Run a 10-minute timelapse (1 shot every 5 seconds = 120 frames):

```bash
cam_timelapse.sh 5 120
```

---

# Troubleshooting

If you see:

Could not claim the USB device

Run:

```bash
killall gvfsd-gphoto2 gvfs-gphoto2-volume-monitor
```

If the camera freezes:

1. Turn camera off
2. Unplug USB
3. Turn camera back on
4. Reconnect USB

---

# Limitations

- USB Live View resolution is limited by hardware
- USB latency cannot match HDMI capture latency
- Video recording control via USB is limited
- Autofocus during Live View may introduce delay

---

# License

Free to use for personal, artistic, and research purposes.
