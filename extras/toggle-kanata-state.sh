#!/usr/bin/env bash
if systemctl --user is-active kanata.service; then
  systemctl --user stop kanata.service
  notify-send -t 1000 "💻   Kanata:  OFF"
elif systemctl --user is-active kanata-g.service; then
  systemctl --user stop kanata-g.service
  notify-send -t 1000 "💻   Kanata:  OFF"
else
  systemctl --user start kanata.service
  notify-send -t 1000 "💻   Kanata:  ON"
fi
