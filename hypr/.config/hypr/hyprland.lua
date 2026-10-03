-- Learn how to configure Hyprland: https://wiki.hypr.land/Configuring/Start/

-- Omarchy's bootstrap keeps path setup out of this user config.
dofile((os.getenv("OMARCHY_PATH") or "/usr/share/omarchy") .. "/default/hypr/bootstrap.lua")

-- Disable all Omarchy default bindings. Add your own in hypr/bindings.lua.
-- omarchy_default_bindings = false

-- Or disable only bindings for Omarchy's preinstalled apps/web apps while
-- keeping core window-manager bindings:
omarchy_preinstalled_bindings = false

-- Load Omarchy defaults.
require("default.hypr.omarchy")

-- Put your personal overrides in these files. They're loaded after Omarchy's
-- defaults so package updates can improve the defaults without rewriting your
-- ~/.config/hypr files.
require("hypr.monitors")
require("hypr.workspaces")
require("hypr.input")
require("hypr.bindings")
require("hypr.looknfeel")
require("hypr.autostart")

-- Toggle config flags dynamically.
require("default.hypr.toggles")

-- # Mark Gamescope as game content
hl.window_rule({
	match = {
		initial_class = "gamescope",
	},
	workspace = 1,
	content = "game",
	immediate = true,
})

-- Steam
hl.window_rule({
	match = {
		initial_class = "steam.*",
		initial_title = "Steam",
	},
	workspace = 7,
	size = "1800 1000",
})

hl.window_rule({
	match = {
		initial_class = "steam.*",
		title = "Friends List",
	},
	workspace = 7,
	size = "350 800",
})

-- Path of Exile 2
hl.window_rule({
	match = {
		initial_class = "steam_app_2694490",
	},
	workspace = 1,
	content = "game",
	immediate = true,
})

-- Path of Building
hl.window_rule({
	match = {
		initial_class = "steam_app_4161373750",
	},
	workspace = 6,
})

-- Btop
hl.window_rule({
	match = {
		initial_class = "org.omarchy.btop",
	},
	tag = "+btop",
})

hl.window_rule({
	match = {
		tag = "btop",
	},
	size = "1430 850",
})

-- Spawn apps on last workspaces
hl.window_rule({
	match = {
		initial_class = "[sS]potify",
	},
	workspace = 11,
})

hl.window_rule({
	match = {
		initial_class = "[vV]esktop",
	},
	workspace = 12,
})

hl.window_rule({
	match = {
		initial_class = ".*chrome.+messages.*",
	},
	workspace = 13,
})

hl.window_rule({
	match = {
		initial_class = ".*chrome.+whatsapp.*",
	},
	workspace = 14,
})

hl.window_rule({
	match = {
		initial_class = ".*chrome.+instagram.*",
	},
	workspace = 15,
})

hl.window_rule({
	match = {
		initial_class = ".*chrome.+messenger.*",
	},
	workspace = 16,
})

hl.window_rule({
	match = {
		initial_class = ".*chrome.+keep.*",
	},
	workspace = 17,
})

hl.window_rule({
	match = {
		initial_class = ".*qBittorrent.*",
	},
	workspace = 18,
})

-- Browsers
hl.window_rule({
	match = {
		initial_class = "[oO]pera",
	},
	fullscreen = true,
})

hl.window_rule({
	match = {
		initial_class = "[Ff]loorp",
	},
	fullscreen = true,
})

hl.window_rule({
	match = {
		initial_class = "([Ff]loorp|xdg-desktop-portal-gtk)",
		initial_title = "(Library|.*File.*Upload.*|.*Folder.*Upload.*)",
	},
	fullscreen = false,
	float = true,
	center = true,
	border_size = 1,
	size = "900 700",
})

hl.window_rule({
	match = {
		initial_class = "([Ff]loorp|xdg-desktop-portal-gtk)",
		initial_title = ".*Removing.*Cookies.*",
	},
	fullscreen = false,
	float = true,
	center = true,
	border_size = 1,
	size = "400 200",
})

-- # Scratchpad-specific tiling
hl.window_rule({
	match = {
		workspace = "special:scratchpad",
	},
	pseudo = true,
	border_size = 1,
	size = "1430 850",
})

hl.workspace_rule({
	workspace = "special:scratchpad",
	gaps_in = 5,
	gaps_out = 15,
})

-- VLC
-- Disable "Resize interface to video size" in preferences
hl.window_rule({
	match = {
		initial_class = "^vlc$",
	},
	float = true,
})

hl.window_rule({
	match = {
		title = ".*VLC.media.player$",
	},
	float = true,
	center = true,
	size = "1430 850",
})

-- Ueberzug
hl.window_rule({
	match = {
		initial_class = ".*ueberzug.*",
	},
	float = true,
	no_anim = true,
	no_focus = true,
	no_dim = true,
	no_shadow = true,
})

-- Tensaku
hl.window_rule({
	match = {
		initial_class = "dev.tensaku.Tensaku",
	},
	tag = "+tensaku",
})

hl.window_rule({
	match = {
		tag = "tensaku",
	},
	size = "monitor_w monitor_h",
})

-- LocalSend
hl.window_rule({
	match = {
		initial_class = ".*org.localsend.*",
	},
	float = true,
	center = true,
	size = "900 700",
})

-- Floorp Extensions (Bitwarden)
hl.on("window.open", function(w)
  if w.class ~= "floorp" then return end
  if w.initial_title ~= "Ablaze Floorp" then return end

  local floorp_windows = hl.get_windows({ class = "floorp" })
  if #floorp_windows <= 1 then return end

  hl.dispatch(hl.dsp.window.fullscreen({ action = "unset", window = w }))
  hl.dispatch(hl.dsp.window.float({ action = "set", window = w }))

  local sub
  sub = hl.on("window.title", function(tw)
    if tw.address ~= w.address then return end
    if tw.title == ""
        or tw.title == "Ablaze Floorp"
        or tw.title == "about:blank"
        or tw.title:match("^about:.*Ablaze Floorp$") then return end

    sub:remove()

    if tw.title:match("^Extension:") then
      hl.dispatch(hl.dsp.window.resize({ x = 600, y = 700, window = tw }))
      hl.dispatch(hl.dsp.window.center({ window = tw }))
      hl.dispatch(hl.dsp.focus({ window = tw }))

      for _, fw in ipairs(floorp_windows) do
        if fw.address ~= w.address then
            hl.dispatch(hl.dsp.window.fullscreen({ action = "set", window = fw }))
            break
        end
      end
    else
        hl.dispatch(hl.dsp.window.float({ action = "unset", window = tw }))
    end

  end)
end)
