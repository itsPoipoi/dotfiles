#!/usr/bin/env sh

# Wallpaper directory
WP_FOLDER=~/Pictures/Wallpapers

# Time in seconds to change wallpaper
sleep 5
WAIT_TIME=1200
STARTPID=$(pidof swaybg)
kill "$STARTPID"

FILE2START=$(find "$WP_FOLDER" -type f -name '*' | shuf -n1)
swaybg -o DP-1 -i "$FILE2START" -m fill &

while true; do
  PID=$(pidof swaybg | awk '{print $2}')
  FILE=$(find "$WP_FOLDER" -type f -name '*' | shuf -n1)
  swaybg -o eDP-1 -o DP-3 -i "$FILE" -m fill &
  sleep 0.5
  kill "$PID"
  sleep "$WAIT_TIME"
  PID=$(pidof swaybg | awk '{print $2}')
  FILE=$(find "$WP_FOLDER" -type f -name '*' | shuf -n1)
  swaybg -o eDP-1 -o DP-1 -i "$FILE" -m fill &
  sleep 0.5
  kill "$PID"
  sleep "$WAIT_TIME"
done
