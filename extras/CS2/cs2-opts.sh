#!/usr/bin/env bash
# shellcheck disable=SC2086

# Keyboard Layout
export XKB_DEFAULT_LAYOUT=fr
export XKB_DEFAULT_VARIANT=ergol_iso
export XMODIFIERS=""

# Steam Overlay
saved_ld_preload="${LD_PRELOAD-}"
unset LD_PRELOAD

# Additional environment variables
XENVS="env
__GL_SHADER_DISK_CACHE_SKIP_CLEANUP=1
SDL_AUDIO_DRIVER=pulse
MESA_VK_WSI_PRESENT_MODE=immediate
LOW_LATENCY_LAYER=1
LOW_LATENCY_LAYER_REFLEX=1
VULKAN_LOW_LATENCY=1
LD_PRELOAD=$saved_ld_preload
"

# Launch options
exec gamemoderun gamescope \
  -f -w 1920 -h 1440 -S stretch -r 300 \
  --adaptive-sync \
  --immediate-flips \
  --force-grab-cursor \
  --force-windows-fullscreen \
  --backend sdl \
  -- \
  $XENVS \
  "$@" \
  -vulkan \
  -threads 7 \
  -nojoy \
  -disable_workshop_command_filtering \
  +engine_low_latency_sleep_after_client_tick true
