-- On Hyprland start:
-- o.launch_on_start("my-service")
o.launch_on_start("uwsm-app -- steam -silent")
hl.on("hyprland.start", function()
	-- hl.exec_cmd("my-service")
	hl.exec_cmd(
		"[workspace special:scratchpad silent; pseudo on; size 1430 850; border_size 1] uwsm-app -- xdg-terminal-exec"
	)
end)
