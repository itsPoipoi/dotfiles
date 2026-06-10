#!/bin/bash
# Get the address of the Bitwarden window
address=$(hyprctl clients -j | jq '.[] | select(.title | contains("Bitwarden")) | .address')

# Get the address of the Floorp window that is not Bitwarden
floorp_address=$(hyprctl clients -j | jq -r '.[] | select(.class == "floorp" and (.title | contains("Bitwarden") | not)) | .address')

# Check if the window is floating
is_floating=$(hyprctl clients -j | jq '.[] | select(.title | contains("Bitwarden")) | .floating')
class=$(hyprctl clients -j | jq '.[] | select(.title | contains("Bitwarden")) | .class')

# If the window is not floating, make it float, then fullscreen browser
if [[ "$is_floating" == "false" && "$class" == '"floorp"' ]]; then
  command="hyprctl --quiet --batch dispatch setfloating address:\"$address\""
  eval "$command"
  sleep 0.5
  command="hyprctl dispatch focuswindow address:\"$floorp_address\""
  eval "$command"
  command="hyprctl dispatch fullscreen"
  eval "$command"
fi

# Resize and move the window
command="hyprctl dispatch resizewindowpixel exact 50% 80%,address:\"$address\""
eval "$command"
command="hyprctl dispatch focuswindow address:\"$address\""
eval "$command"
command="hyprctl dispatch centerwindow"
eval "$command"
command="hyprctl dispatch focuswindow address:\"$address\""
eval "$command"
