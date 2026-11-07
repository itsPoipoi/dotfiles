#!/usr/bin/env bash

if systemctl --user is-active kanata.service; then
  systemctl --user stop kanata.service
  notify-send -t 750 "💻   Kanata:  OFF"
else
  systemctl --user start kanata.service
  notify-send -t 750 "💻   Kanata:  DEFAULT"
fi
