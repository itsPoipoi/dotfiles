#!/usr/bin/env bash
if systemctl --user is-active kanata.service; then
  systemctl --user stop kanata.service
  hyprctl switchxkblayout all 1
  notify-send "💻   Azerty"
else
  systemctl --user start kanata.service
  hyprctl switchxkblayout all 0
  notify-send "💻   Ergo-L"
fi
