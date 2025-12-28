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
  PID2=$(pidof swaybg | awk '{print $3}')
  PID3=$(pidof swaybg | awk '{print $4}')
  FILE=$(find "$WP_FOLDER" -type f -name '*' | shuf -n1)
  swaybg -o DP-3 -i "$FILE" -m fill &
  swaybg -o eDP-1 -i "$FILE" -m fill &
  sleep 0.5
  kill "$PID"
  kill "$PID2"
  kill "$PID3"
  sleep "$WAIT_TIME"
  PID=$(pidof swaybg | awk '{print $2}')
  FILE=$(find "$WP_FOLDER" -type f -name '*' | shuf -n1)
  swaybg -o DP-1 -i "$FILE" -m fill &
  swaybg -o eDP-1 -i "$FILE" -m fill &
  sleep 0.5
  kill "$PID"
  kill "$PID2"
  kill "$PID3"
  sleep "$WAIT_TIME"
done
