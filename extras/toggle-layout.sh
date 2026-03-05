#!/usr/bin/env bash
if hyprctl devices | grep "Ergo‑L"; then
  systemctl --user stop kanata.service
  hyprctl switchxkblayout all 1
  notify-send -t 1000 "💻   Layout:  AZERTY   |   Kanata:  OFF"
else
  systemctl --user start kanata.service
  hyprctl switchxkblayout all 0
  notify-send -t 1000 "💻   Layout:  ERGO-L   |   Kanata:  ON"
fi
