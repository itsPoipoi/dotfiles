#!/usr/bin/env bash

STATE_FILE="${XDG_RUNTIME_DIR:-/tmp}/kanata-state"

if systemctl --user is-active kanata.service; then
  systemctl --user stop kanata.service
  notify-send -t 750 "💻   Kanata:  OFF"
else
  systemctl --user start kanata.service
  notify-send -t 750 "💻   Kanata:  DEFAULT"
  printf 'default' > "$STATE_FILE"
fi
