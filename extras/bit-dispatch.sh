#!/bin/bash
# Get the address of the Bitwarden window
address=$(hyprctl clients -j | jq '.[] | select(.title | contains("Bitwarden")) | .address')

# Get the address of the Floorp window
floorp_address=$(hyprctl clients -j | jq -r '.[] | select(.class == "floorp" and (.title | contains("Bitwarden") | not)) | .address')

# Check if the Bitwarden window is floating
is_floating=$(hyprctl clients -j | jq '.[] | select(.title | contains("Bitwarden")) | .floating')
class=$(hyprctl clients -j | jq '.[] | select(.title | contains("Bitwarden")) | .class')

# If the Bitwarden window is not floating, make it float, then fullscreen Floorp
if [[ "$is_floating" == "false" && "$class" == '"floorp"' ]]; then
  command="hyprctl dispatch \"hl.dsp.window.float({ window = 'address:$address', action = 'toggle' })\""
  eval "$command"
  sleep 0.5
  command="hyprctl dispatch \"hl.dsp.window.fullscreen({ window = 'address:$floorp_address', action = 'set' })\""
  eval "$command"
fi

# Resize and move the Bitwarden window
command="hyprctl dispatch resizewindowpixel exact 50% 80%,address:\"$address\""
command="hyprctl dispatch \"hl.dsp.window.resize({ window = 'address:$address' })\""
eval "$command"
command="hyprctl dispatch \"hl.dsp.focus({ window = 'address:$address' })\""
eval "$command"
command="hyprctl dispatch centerwindow"
eval "$command"
command="hyprctl dispatch \"hl.dsp.focus({ window = 'address:$address' })\""
eval "$command"
