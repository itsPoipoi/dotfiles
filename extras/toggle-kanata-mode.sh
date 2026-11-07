#!/usr/bin/env bash
# Bound to SUPER+F1. When kanata is running, its own SUPER+F1 chord already
# reloads the next config and kanata-notify.service sends the notification.
# This script only handles the case where kanata isn't running yet.

if ! systemctl --user is-active --quiet kanata.service; then
    systemctl --user start kanata.service
    hyprctl switchxkblayout all 0
    notify-send -t 1000 "💻   Layout:  ERGO-L   |   Kanata:  DEFAULT"
fi
