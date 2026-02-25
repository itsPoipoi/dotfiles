require("git"):setup({
	-- Order of status signs showing in the linemode
	order = 1500,
})

require("relative-motions"):setup({
	show_numbers = "relative_absolute", -- relative_absolute or none
	show_motion = true,
	only_motions = false,
	enter_mode = "cache_or_first",
})

-- https://github.com/hankertrix/augment-command.yazi?tab=readme-ov-file#configuration
th.create_title = { "Create and open:", "Create (dir):" }
require("augment-command"):setup({
	prompt = false,
	default_item_group_for_prompt = "hovered",
	smart_enter = false,
	smart_paste = true,
	skip_single_subdirectory_on_enter = true,
	skip_single_subdirectory_on_leave = true,
	use_default_create_behaviour = true,
	create_item_delay = 0.25,
	enter_archives = false,
	extract_retries = 3,
	recursively_extract_archives = true,
	reveal_created_archive = true,
	must_have_hovered_item = false,
})
