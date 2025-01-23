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
}

return M
