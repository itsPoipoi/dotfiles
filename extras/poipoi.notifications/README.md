# My Notifications

A clone of Omarchy's built-in `omarchy.notifications` plugin (v2.0.0) with shorter popup timeouts.

## What's different

Upstream keeps every popup on screen for at least 5s (low) or 8s (normal), even if the app asks for less. This plugin uses short defaults and respects the app's requested timeout.

| | Upstream | This plugin |
|---|---|---|
| Low urgency default | 5s | 2s |
| Normal urgency default | 8s | 2.5s |
| Max timeout | 30s | 15s |
| App requests a timeout | Raised to the minimum above | Used as requested, up to the max |
| Critical | Stays until dismissed | Same |

The only code change is `durationFor()` and the three duration constants in `Service.qml`. Everything else is unchanged from upstream.

## Install

Copy this folder to `~/.config/omarchy/plugins/poipoi.notifications`, then enable it and disable `omarchy.notifications`:

```
omarchy-plugin-enable poipoi.notifications
omarchy-plugin-disable omarchy.notifications
```

Restart the shell afterwards.

## Tweaking

Edit `lowDuration`, `normalDuration` and `maxDuration` near the top of the "lifetime" section in `Service.qml` (values in milliseconds).
