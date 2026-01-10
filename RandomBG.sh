#!/usr/bin/env sh

# Wallpaper directory
WP_FOLDER=~/Pictures/Wallpapers

# Time in seconds to change wallpaper
sleep 5
WAIT_TIME=1200

# Cache wallpaper list for efficiency
WALLPAPERS=$(find "$WP_FOLDER" -type f -name '*')

# Add signal handling for graceful shutdown
trap 'echo "Terminating..."; killall swaybg 2>/dev/null; exit' INT TERM

STARTPID=$(pidof swaybg)
kill "$STARTPID"

FILE2START=$(echo "$WALLPAPERS" | shuf -n1)
swaybg -o DP-1 -i "$FILE2START" -m fill &

while true; do
  # Get all PIDs in one call for efficiency
  PIDS=$(pidof swaybg)
  PID=$(echo "$PIDS" | awk '{print $3}')
  PID2=$(echo "$PIDS" | awk '{print $4}')
  PID3=$(echo "$PIDS" | awk '{print $5}')

  # Use cached wallpaper list
  FILE=$(echo "$WALLPAPERS" | shuf -n1)
  swaybg -o DP-3 -i "$FILE" -m fill &
  swaybg -o eDP-1 -i "$FILE" -m fill &
  sleep 0.5

  # Add error checking for kill operations
  kill "$PID" 2>/dev/null || true
  kill "$PID2" 2>/dev/null || true
  kill "$PID3" 2>/dev/null || true
  sleep "$WAIT_TIME"

  # Get all PIDs in one call for efficiency
  PIDS=$(pidof swaybg)
  PID=$(echo "$PIDS" | awk '{print $3}')
  PID2=$(echo "$PIDS" | awk '{print $4}')
  PID3=$(echo "$PIDS" | awk '{print $5}')

  # Use cached wallpaper list
  FILE=$(echo "$WALLPAPERS" | shuf -n1)
  swaybg -o DP-1 -i "$FILE" -m fill &
  swaybg -o eDP-1 -i "$FILE" -m fill &
  sleep 0.5

  # Add error checking for kill operations
  kill "$PID" 2>/dev/null || true
  kill "$PID2" 2>/dev/null || true
  kill "$PID3" 2>/dev/null || true
  sleep "$WAIT_TIME"
done
