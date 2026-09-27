-- Remove default bindings
hl.unbind("SUPER + W")
hl.unbind("SUPER + K")
hl.unbind("SUPER + L")
hl.unbind("SUPER + G")
hl.unbind("SUPER + Slash")
hl.unbind("SUPER + code:21")
hl.unbind("SUPER + code:61")
-- hl.unbind("PRINT")
-- hl.unbind("SUPER + PRINT")
hl.unbind("SUPER + ALT + S")
hl.unbind("SUPER + ALT + SPACE")
hl.unbind("SUPER + SHIFT + B")
hl.unbind("SUPER + SHIFT + F")
hl.unbind("SUPER + SHIFT + BACKSPACE")
hl.unbind("SUPER + SHIFT + RETURN")
hl.unbind("SUPER + CTRL + Z")
hl.unbind("SUPER + CTRL + BACKSPACE")
hl.unbind("XF86AudioRaiseVolume")
hl.unbind("XF86AudioLowerVolume")
hl.unbind("ALT + XF86AudioRaiseVolume")
hl.unbind("ALT + XF86AudioLowerVolume")
hl.unbind("SUPER + SHIFT + CTRL + A")

-- My bindings
o.bind("SUPER + SHIFT + K", "Keybindings", "omarchy-menu-keybindings")
o.bind("SUPER + R", "Apps menu", "omarchy-menu toggle apps")
o.bind("SUPER + Q", "Close window", hl.dsp.window.close())
o.bind(
	"SUPER + SHIFT + S",
	"Move window to scratchpad",
	hl.dsp.window.move({ workspace = "special:scratchpad", follow = false })
)

-- bindd = SUPER SHIFT, BACKSPACE, Toggle focus mode, exec, $HOME/dotfiles/extras/toggle-focus.sh

o.bind("SUPER + CTRL + V", "Clipboard manager", "omarchy-shell shell toggle omarchy.clipboard")
o.bind("SUPER + Z", "Show time", "omarchy-notification-time -t 1500")
o.bind("SUPER + SHIFT + Z", "Show battery", "omarchy-notification-battery -t 1500")
o.bind("SUPER + CTRL + Z", "Dismiss all notifications", "omarchy-shell notifications dismissAll")
o.bind("SUPER + SHIFT + C", "Calendar", "omarchy-shell shell toggle omarchy.clock")

o.bind("SUPER + Control_R", "Toggle Kanata Mode", "$HOME/dotfiles/extras/toggle-kanata-mode.sh")
o.bind("SUPER + ALT + Control_R", "Toggle Kanata State", "$HOME/dotfiles/extras/toggle-kanata-state.sh")
o.bind("SUPER + SHIFT + Control_R", "Toggle Keyboard Layout", "$HOME/dotfiles/extras/toggle-layout.sh")

-- Volume controls
o.bind("XF86AudioRaiseVolume", "Volume up", "omarchy-audio-output-volume +1", { locked = true, repeating = true })
o.bind("XF86AudioLowerVolume", "Volume down", "omarchy-audio-output-volume -1", { locked = true, repeating = true })

-- Microphone controls
-- bindd = ALT, Equal, Toggle Microphone, exec, $HOME/dotfiles/extras/toggle-mic.sh # System-wide mute
-- bindn = , Equal, sendshortcut, CTRL SHIFT, M, class:^(vesktop)$ # Discord mute
-- bindni = , mouse:276, sendshortcut, CTRL SHIFT, Y, class:^(vesktop)$ # Discord PTT

-- Application bindings
o.bind("SUPER + E", "Yazi", "uwsm-app -- xdg-terminal-exec --hold kitty @ send-text y'\r'")
o.bind("SUPER + SHIFT + E", "Thunar", "uwsm-app -- thunar")
o.bind("SUPER + B", "Browser", "omarchy-launch-or-focus floorp")
o.bind("SUPER + SHIFT + B", "Neflix (Opera)", "omarchy-launch-or-focus opera")
o.bind("SUPER + M", "Music", "omarchy-launch-or-focus spotify")
o.bind("SUPER + N", "Editor", { omarchy = "editor" })
o.bind("SUPER + D", "Discord", "omarchy-launch-or-focus vesktop")
o.bind("SUPER + Y", "YouTube", "xdg-open https://youtube.com/feed/subscriptions")
o.bind("SUPER + SHIFT + A", "Agent", "omarchy-agent --pick")

-- WebApps
o.bind("SUPER + A", "ChatGPT", "omarchy-launch-or-focus-webapp ChatGPT https://chatgpt.com")
o.bind("SUPER + H", "WhatsApp", "omarchy-launch-or-focus-webapp WhatsApp https://web.whatsapp.com/")
o.bind(
	"SUPER + G",
	"Google Messages",
	"omarchy-launch-or-focus-webapp Google.Messages https://messages.google.com/web/conversations"
)
o.bind(
	"SUPER + I",
	"Instagram Messages",
	"omarchy-launch-or-focus-webapp Instagram https://www.instagram.com/direct/inbox/"
)
o.bind("SUPER + U", "Facebook Messenger", "omarchy-launch-or-focus-webapp Messenger https://www.messenger.com")
o.bind("SUPER + K", "Keep Notes", "omarchy-launch-or-focus-webapp Google.Keep https://keep.google.com")
-- bindd = SHIFT SUPER, M, Open Message WebApps, exec, $HOME/dotfiles/extras/messages-open.sh
-- bindd = CTRL SUPER, M, Close Message WebApps, exec, $HOME/dotfiles/extras/messages-close.sh

-- # Path of Exile 2
-- bindne = CTRL, mouse:276, sendshortcut, ,LEFT, class:^(steam_app_2694490)$
-- bindne = CTRL, mouse:275, sendshortcut, ,RIGHT, class:^(steam_app_2694490)$
