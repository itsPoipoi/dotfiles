#!/usr/bin/env bash
hyprctl dispatch 'hl.dsp.window.close({ window = "class:.*[Mm]essages.*" })'
hyprctl dispatch 'hl.dsp.window.close({ window = "class:.*[iI]nstagram.*" })'
hyprctl dispatch 'hl.dsp.window.close({ window = "class:.*[wW]hats[aA]pp.*" })'
hyprctl dispatch 'hl.dsp.window.close({ window = "class:.*[mM]essenger.*" })'
