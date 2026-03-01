#!/usr/bin/env bash
if hyprctl devices | grep "Ergo"; then
  systemctl --user stop kanata.service
  hyprctl switchxkblayout all 1
  notify-send "💻   Azerty"
else
  systemctl --user start kanata.service
  hyprctl switchxkblayout all 0
  notify-send "💻   Ergo-L"
fi
