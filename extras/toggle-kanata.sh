#!/usr/bin/env bash
if hyprctl devices | grep "Ergo‑L"; then
  if systemctl --user is-active kanata.service; then
    systemctl --user stop kanata.service
    notify-send -t 1000 "💻   Kanata:  OFF"
  else
    systemctl --user start kanata.service
    notify-send -t 1000 "💻   Kanata:  ON"
  fi
else
  systemctl --user start kanata.service
  hyprctl switchxkblayout all 0
  notify-send -t 1000 "💻   Layout:  ERGO-L   |   Kanata:  ON"
fi
