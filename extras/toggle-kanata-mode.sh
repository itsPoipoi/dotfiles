#!/usr/bin/env bash
if hyprctl devices | grep "Ergo‑L"; then
  if systemctl --user is-active kanata.service; then
    systemctl --user stop kanata.service
    systemctl --user start kanata-g.service
    notify-send -t 1000 "🎮️   Kanata:  GAME"
  else
    systemctl --user stop kanata-g.service
    systemctl --user start kanata.service
    notify-send -t 1000 "💻   Kanata:  DEFAULT"
  fi
else
  systemctl --user start kanata.service
  hyprctl switchxkblayout all 0
  notify-send -t 1000 "💻   Layout:  ERGO-L   |   Kanata:  DEFAULT"
fi
