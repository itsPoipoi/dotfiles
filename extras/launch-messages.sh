#!/usr/bin/env bash
omarchy-launch-or-focus-webapp "Messenger" "https://www.messenger.com" &>/dev/null &
sleep 0.5
omarchy-launch-or-focus-webapp "Instagram" "https://www.instagram.com/direct/inbox/" &>/dev/null &
sleep 0.5
omarchy-launch-or-focus-webapp "WhatsApp" "https://web.whatsapp.com/" &>/dev/null &
sleep 0.5
omarchy-launch-or-focus-webapp "Google.Messages" "https://messages.google.com/web/conversations" &>/dev/null &
