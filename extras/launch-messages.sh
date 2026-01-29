#!/usr/bin/env bash
omarchy-launch-or-focus-webapp "Messenger" "https://www.messenger.com" &>/dev/null &
omarchy-launch-or-focus-webapp "Instagram" "https://www.instagram.com/direct/inbox/" &>/dev/null &
omarchy-launch-or-focus-webapp "WhatsApp" "https://web.whatsapp.com/" &>/dev/null &
omarchy-launch-or-focus-webapp "Messages" "https://messages.google.com/web/conversations" &>/dev/null &
sleep 1
omarchy-launch-or-focus-webapp "Messages" "https://messages.google.com/web/conversations" &>/dev/null &
