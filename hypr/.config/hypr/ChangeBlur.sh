#!/usr/bin/env bash
# Script for changing blurs on the fly

STATE=$(hyprctl -j getoption decoration:blur:enabled | jq ".int")

if [ "${STATE}" == "0" ]; then
  hyprctl keyword decoration:blur:enabled 1
  hyprctl keyword decoration:blur:size 2
  hyprctl keyword decoration:blur:passes 2
  hyprctl keyword decoration:blur:brightness 0.35
else
  hyprctl keyword decoration:blur:enabled 0
  hyprctl keyword decoration:blur:size 1
  hyprctl keyword decoration:blur:passes 1
  hyprctl keyword decoration:blur:brightness 0.7
fi
