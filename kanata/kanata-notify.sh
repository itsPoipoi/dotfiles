#!/usr/bin/env bash
# Follows kanata's TCP events and keeps the notification + state file in sync
# with the config kanata is actually running (single source of truth).
# Run by kanata-notify.service, which is bound to kanata.service: whenever kanata
# (re)starts it begins on the first --cfg (default), so every connection = default.

PORT=5829
STATE_FILE="${XDG_RUNTIME_DIR:-/tmp}/kanata-state"

set_state() {
  printf '%s' "$1" > "$STATE_FILE"
}

# Wait for kanata's TCP server to come up
until exec 3<>"/dev/tcp/127.0.0.1/$PORT"; do sleep 0.5; done 2>/dev/null

set_state default

while IFS= read -r line <&3; do
  new=$(jq -r '.ConfigFileReload.new // empty' <<<"$line" 2>/dev/null)
  [[ -z "$new" ]] && continue
  if [[ "$new" == *-g.kbd ]]; then
    set_state game
    notify-send -t 750 "🎮️   Kanata:  GAME"
  else
    set_state default
    notify-send -t 750 "💻   Kanata:  DEFAULT"
  fi
done
exit 1  # connection lost -> let systemd restart us
