#!/usr/bin/env bash
if wpctl get-volume @DEFAULT_AUDIO_SOURCE@ | grep "MUTED"; then
  wpctl set-mute @DEFAULT_AUDIO_SOURCE@ 0
  notify-send -t 500 "🔊   Microphone:  ON"
  canberra-gtk-play -i device-added -V 15
else
  wpctl set-mute @DEFAULT_AUDIO_SOURCE@ 1
  notify-send -t 500 "🔇   Microphone:  OFF"
  canberra-gtk-play -i device-removed -V 15
fi
