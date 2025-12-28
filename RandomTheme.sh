#!/usr/bin/env sh

WP_FOLDER=~/Pictures/Wallpapers
FILE1=$(find "$WP_FOLDER" -type f -name '*' | shuf -n1)
FILE2=$(find "$WP_FOLDER" -type f -name '*' | shuf -n1)

THEME=$(find "$HOME/.config/omarchy/themes/" -maxdepth 1 ! -name 'themes' -name '*' -exec basename {} \; | shuf -n1)
omarchy-theme-set $THEME
swaybg -o eDP-1 -i "$FILE1" -m fill &
swaybg -o DP-3 -i "$FILE1" -m fill &
swaybg -o DP-1 -i "$FILE2" -m fill &
notify-send "Changed theme to: $THEME"
