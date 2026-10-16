#!/usr/bin/env bash

STATE_FILE="${XDG_RUNTIME_DIR:-/tmp}/kanata-state"

if hyprctl devices | grep "Ergo‑L"; then
    if systemctl --user is-active --quiet kanata.service; then
        if [[ "$(cat "$STATE_FILE" 2>/dev/null)" != "game" ]]; then
            notify-send -t 1000 "🎮️   Kanata:  GAME"
            printf 'game' > "$STATE_FILE"
        else
            notify-send -t 1000 "💻   Kanata:  DEFAULT"
            printf 'default' > "$STATE_FILE"
        fi
    else
        systemctl --user start kanata.service
        notify-send -t 1000 "💻   Kanata:  DEFAULT"
        printf 'default' > "$STATE_FILE"
    fi
else
    systemctl --user start kanata.service
    hyprctl switchxkblayout all 0
    notify-send -t 1000 "💻   Layout:  ERGO-L   |   Kanata:  DEFAULT"
    printf 'default' > "$STATE_FILE"
fi


