-- Remove default bindings
hl.unbind("SUPER + W")
hl.unbind("SUPER + Slash")
hl.unbind("SUPER + code:21")
hl.unbind("SUPER + code:61")
hl.unbind("SUPER + ALT + S")
hl.unbind("SUPER + SHIFT + F")
hl.unbind("SUPER + SHIFT + RETURN")
hl.unbind("SUPER + SHIFT + CTRL + A")

-- My bindings
o.bind("SUPER + SHIFT + K", "Keybindings", "omarchy-menu-keybindings")
o.bind("SUPER + R", "Apps menu", "omarchy-menu toggle apps")
o.bind("SUPER + Q", "Close window", hl.dsp.window.close())
o.bind("SUPER + SHIFT + S", "Move window to scratchpad", hl.dsp.window.move({ workspace = "special:scratchpad", follow = false }))

o.rebind("SUPER + SHIFT + N", "Toggle Nightlight", "omarchy-toggle-nightlight")
o.bind("SUPER + Z", "Show time", "omarchy-notification-time")
o.bind("SUPER + SHIFT + Z", "Show battery", "omarchy-notification-battery")
o.bind("SUPER + SHIFT + P", "Show power-manager", "omarchy-shell shell toggle onlyvishesh.power-manager")
o.rebind("SUPER + CTRL + Z", "Dismiss all notifications", "omarchy-shell notifications dismissAll")
o.bind("SUPER + SHIFT + C", "Calendar", "omarchy-shell shell toggle omarchy.clock")

o.bind("SUPER + F1", "Toggle Kanata Mode", "$HOME/dotfiles/extras/toggle-kanata-mode.sh")
o.bind("SUPER + F2", "Toggle Keyboard Layout", "$HOME/dotfiles/extras/toggle-layout.sh")
o.bind("SUPER + F3", "Toggle Kanata State", "$HOME/dotfiles/extras/toggle-kanata-state.sh")

-- Volume controls
o.rebind("XF86AudioRaiseVolume", "Volume up", "omarchy-audio-output-volume +1", { locked = true, repeating = true })
o.rebind("XF86AudioLowerVolume", "Volume down", "omarchy-audio-output-volume -1", { locked = true, repeating = true })

-- Microphone controls
o.bind("ALT + Equal", "Mute microphone", "omarchy-audio-input-mute; canberra-gtk-play -i device-removed -V 15", { locked = true })
hl.bind("Equal", hl.dsp.send_shortcut({ mods = "CTRL + SHIFT", key = "M", window = "class:^(vesktop)$" }), {non_consuming = true})
hl.bind("mouse:276", hl.dsp.send_shortcut({ mods = "CTRL + SHIFT", key = "Y", window = "class:^(vesktop)$" }), {non_consuming = true, ignore_mods = true})

-- Application bindings
o.bind("SUPER + E", "Yazi", "uwsm-app -- xdg-terminal-exec --hold kitty @ send-text y'\r'")
o.bind("SUPER + SHIFT + E", "Thunar", "uwsm-app -- thunar")
o.bind("SUPER + B", "Browser", "omarchy-launch-or-focus floorp")
o.rebind("SUPER + SHIFT + B", "Neflix (Opera)", "omarchy-launch-or-focus opera")
o.rebind("SUPER + M", "Music", "omarchy-launch-or-focus spotify")
o.bind("SUPER + N", "Editor", { omarchy = "editor" })
o.bind("SUPER + D", "Discord", "omarchy-launch-or-focus vesktop")
o.bind("SUPER + Y", "YouTube", "xdg-open https://youtube.com/feed/subscriptions")
o.bind("SUPER + SHIFT + A", "Agent", "omarchy-agent --pick")

-- WebApps
o.rebind("SUPER + A", "ChatGPT", "omarchy-launch-or-focus-webapp ChatGPT https://chatgpt.com")
o.bind("SUPER + H", "WhatsApp", "omarchy-launch-or-focus-webapp WhatsApp https://web.whatsapp.com/")
o.rebind( "SUPER + G", "Google Messages", "omarchy-launch-or-focus-webapp Google.Messages https://messages.google.com/web/conversations")
o.bind( "SUPER + I", "Instagram Messages", "omarchy-launch-or-focus-webapp Instagram https://www.instagram.com/direct/inbox/")
o.bind("SUPER + U", "Facebook Messenger", "omarchy-launch-or-focus-webapp Messenger https://www.messenger.com")
o.rebind("SUPER + K", "Keep Notes", "omarchy-launch-or-focus-webapp Google.Keep https://keep.google.com")
o.bind("SUPER + SHIFT + M", "Open Message WebApps", "$HOME/dotfiles/extras/messages-open.sh")
o.bind("SUPER + CTRL + M", "Close Message WebApps", "$HOME/dotfiles/extras/messages-close.sh")

-- # Path of Exile 2
hl.bind("CTRL + mouse:276", hl.dsp.send_shortcut({ mods = "", key = "LEFT", window = "class:^(steam_app_2694490)$" }), {non_consuming = true, repeating = true})
hl.bind("CTRL + mouse:275", hl.dsp.send_shortcut({ mods = "", key = "RIGHT", window = "class:^(steam_app_2694490)$" }), {non_consuming = true, repeating = true})

-- Focus Mode
o.rebind("SUPER + SHIFT + BACKSPACE", "Toggle Focus Mode", function()
	local focus_mode = (hl.get_config("decoration.blur.enabled") == true)

	if focus_mode then
		hl.exec_cmd("hyprctl reload")
		return
	end

	hl.config({
		decoration = {
			blur = {
				enabled = true,
				size = 3,
				passes = 3,
				brightness = 0.25,
			},
		},
	})
end)
