#!/usr/bin/env bash
if hyprctl devices | grep "Ergo"; then
  if systemctl --user is-active kanata.service; then
    systemctl --user stop kanata.service
    notify-send "💻   Kanata:  OFF"
  else
    systemctl --user start kanata.service
    notify-send "💻   Kanata:  ON"
  fi
else
  systemctl --user start kanata.service
  hyprctl switchxkblayout all 0
  notify-send "💻   Layout:  ERGO-L   |   Kanata:  ON"
fi
