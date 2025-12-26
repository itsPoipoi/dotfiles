#!/usr/bin/env bash
# Script for changing blurs on the fly

STATE=$(hyprctl -j getoption decoration:blur:passes | jq ".int")

if [ "${STATE}" == "1" ]; then
	hyprctl keyword decoration:blur:size 2
	hyprctl keyword decoration:blur:passes 2
	hyprctl keyword decoration:blur:brightness 0.4
else
	hyprctl keyword decoration:blur:size 1
	hyprctl keyword decoration:blur:passes 1
	hyprctl keyword decoration:blur:brightness 0.7
fi
