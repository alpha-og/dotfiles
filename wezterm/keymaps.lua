local M = {}
local wezterm = require("wezterm")
local act = wezterm.action
local keycher = require("plugins.keycher")

-- leader key
M.leader = {
	key = "a",
	mods = "CTRL",
}

-- disable the default keybinding for alt-enter
local keys = {
	{
		key = "Enter",
		mods = "ALT",
		action = wezterm.action.DisableDefaultAssignment,
	},
	-- Prompt for a name to use for a new workspace and switch to it.
	{
		key = "N",
		mods = "LEADER",
		action = act.PromptInputLine({
			description = wezterm.format({
				{ Attribute = { Intensity = "Bold" } },
				{ Foreground = { AnsiColor = "Fuchsia" } },
				{ Text = "Enter name for new workspace" },
			}),
			action = wezterm.action_callback(function(window, pane, line)
				-- line will be `nil` if they hit escape without entering anything
				-- An empty string if they just hit enter
				-- Or the actual line of text they wrote
				if line then
					window:perform_action(
						act.SwitchToWorkspace({
							name = line,
						}),
						pane
					)
				end
			end),
		}),
	},
	-- Create a new workspace with a random name and switch to it
	{ key = "n", mods = "LEADER", action = act.SwitchToWorkspace },
	-- Switch to a monitoring workspace, which will have `btop` launched into it
	{
		key = "p",
		mods = "LEADER",
		action = act.SwitchToWorkspace({
			name = "monitoring",
			spawn = {
				args = {
					"/opt/homebrew/bin/btop",
				},
			},
		}),
	},

	-- Show the launcher in fuzzy selection mode and have it list all workspaces
	-- and allow activating one.
	{
		key = "f",
		mods = "LEADER",
		action = act.ShowLauncherArgs({
			flags = "FUZZY|WORKSPACES",
		}),
	},
}

keycher.apply_keys(keys, keycher.keys)
M.keys = keys

return M
