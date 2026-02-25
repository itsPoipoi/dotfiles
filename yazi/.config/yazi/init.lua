require("git"):setup({
	-- Order of status signs showing in the linemode
	order = 1500,
})

-- ~/.config/yazi/init.lua
require("relative-motions"):setup({
	show_numbers = "relative_absolute", -- relative_absolute or none
	show_motion = true,
	only_motions = false,
	enter_mode = "cache_or_first",
})
