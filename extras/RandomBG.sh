#!/usr/bin/env sh

WP_FOLDER=~/Pictures/Wallpapers
WALLPAPERS=$(find "$WP_FOLDER" -type f -name '*')
CURRENT_BACKGROUND_LINK="$HOME/.config/omarchy/current/background"

# Change 2nd monitor background on startup
sleep 3
FILE=$(echo "$WALLPAPERS" | shuf -n1)
swaybg -o DP-1 -i "$FILE" -m fill &

# Time in seconds to change wallpaper
WAIT_TIME=1200
sleep "$WAIT_TIME"

# Add signal handling for graceful shutdown
trap 'echo "Terminating..."; killall swaybg 2>/dev/null; exit' INT TERM

STARTPID=$(pidof swaybg)
kill "$STARTPID"

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
  # Set new background symlink
  ln -nsf "$FILE" "$CURRENT_BACKGROUND_LINK"
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
  # Set new background symlink
  ln -nsf "$FILE" "$CURRENT_BACKGROUND_LINK"
  sleep 0.5

  # Add error checking for kill operations
  kill "$PID" 2>/dev/null || true
  kill "$PID2" 2>/dev/null || true
  kill "$PID3" 2>/dev/null || true
  sleep "$WAIT_TIME"
done
