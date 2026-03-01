#!/usr/bin/env bash
if systemctl --user is-active kanata.service; then
  systemctl --user stop kanata.service
  notify-send "💻   Stopping Kanata"
else
  systemctl --user start kanata.service
  notify-send "💻   Starting Kanata"
fi
