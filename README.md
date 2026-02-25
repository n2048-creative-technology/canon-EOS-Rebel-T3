
# Canon EOS 1100D (Rebel T3) – gPhoto2 Control Scripts

This repository contains Bash scripts for controlling a Canon EOS 1100D (Rebel T3)
using gphoto2 on Ubuntu/Linux.

These scripts allow you to:

- Capture photos directly to your laptop
- Run timelapses with adjustable timing
- Start low-latency Live View streaming
- Stop Live View cleanly
- Record Live View video directly to your laptop

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

Disable automount permanently:

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

```bash
cam_shoot.sh
cam_shoot.sh 5
cam_shoot.sh 10 ~/Pictures/test_shoot
```

### What It Does

- Stops GNOME camera auto-mount services
- Sets capture target to laptop
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

### Notes

- USB Live View resolution is limited by hardware.
- Minimum latency is typically ~200–400 ms.
- For ultra-low latency, HDMI capture hardware is required.

---

## 3) cam_live_stop.sh

Stop Live View cleanly.

### Usage

```bash
cam_live_stop.sh
```

---

## 4) cam_timelapse.sh

Run a timelapse with adjustable interval and frame count.

### Usage

```bash
cam_timelapse.sh <interval_seconds> <frames> [output_directory]
```

### Examples

```bash
cam_timelapse.sh 5 120
cam_timelapse.sh 2 300
cam_timelapse.sh 10 360 ~/Pictures/sunset_timelapse
```

### What It Does

- Stops GNOME auto-mount conflicts
- Sets capture target to laptop
- Uses gphoto2 built-in interval shooting
- Saves timestamped frames

---

## 5) cam_record_liveview.sh

Record the Canon Live View stream (MJPEG over USB) directly to a video file on your laptop.

This records the USB live stream, not the camera’s internal H.264 movie file.

### Usage

```bash
cam_record_liveview.sh [output_file] [duration_seconds] [mode]
```

### Modes

- fast → low CPU usage, larger files
- hq → higher quality per size, more CPU

### Examples

```bash
cam_record_liveview.sh
cam_record_liveview.sh ./test.mp4 10 fast
cam_record_liveview.sh ~/Videos/live.mp4 60 hq
```

### Notes

- No audio is recorded (USB Live View does not transmit audio).
- Resolution is limited by the camera’s USB Live View capabilities.
- For highest quality video recording, use HDMI output + capture card.

---

# Recommended Camera Settings

For stable operation:

- Mode dial: Manual (M)
- Disable autofocus for timelapse work
- Disable image review
- Use fully charged battery
- Use short, high-quality USB cable

---

# Example Workflow

Start Live View:

```bash
cam_live.sh
```

Record 30 seconds of Live View:

```bash
cam_record_liveview.sh ./clip.mp4 30 hq
```

Take 20 stills:

```bash
cam_shoot.sh 20
```

Run a 10-minute timelapse (1 shot every 5 seconds):

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
- No audio over USB Live View
- In-camera movie recording cannot be started reliably via gphoto2 on this model

---

# License

Free to use for personal, artistic, and research purposes.
