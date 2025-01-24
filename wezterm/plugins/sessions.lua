local M = {}
local wezterm = require("wezterm")
local workspace_switcher = wezterm.plugin.require("https://github.com/MLFlexer/smart_workspace_switcher.wezterm")
M.keys = {
	{
		key = ";",
		mods = "CTRL",
		action = workspace_switcher.switch_workspace(),
	},
	{
		key = "Tab",
		mods = "CTRL",
		action = workspace_switcher.switch_to_prev_workspace(),
	},

	-- {
	-- 	key = "R",
	-- 	mods = "LEADER",
	-- 	action = wezterm.mux.rename_workspace(wezterm.mux.get_active_workspace(), "something different"),
	-- },
}

return M
