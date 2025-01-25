local M = {}
local keycher = require("plugins.keycher")

-- leader key
M.leader = {
	key = "a",
	mods = "CTRL",
}

M.setup = function(wezterm, config)
	local workspace_switcher = wezterm.plugin.require("https://github.com/MLFlexer/smart_workspace_switcher.wezterm")
	local resurrect = wezterm.plugin.require("https://github.com/MLFlexer/resurrect.wezterm")
	local keys = {
		-- disable specific default keybindings
		{
			key = "Enter",
			mods = "ALT",
			action = wezterm.action.DisableDefaultAssignment,
		},
		{
			key = "Tab",
			mods = "CTRL",
			action = wezterm.action.DisableDefaultAssignment,
		},
		-- remap debug overlay keybinding
		{
			key = "d",
			mods = "CTRL|SHIFT",
			action = wezterm.action.ShowDebugOverlay,
		},
		-- split panes
		{
			key = "s",
			mods = "LEADER",
			action = wezterm.action.SplitPane({
				direction = "Down",
				-- size = { Percent = 30 },
			}),
		},
		{
			key = "v",
			mods = "LEADER",
			action = wezterm.action.SplitPane({
				direction = "Right",
			}),
		},
		{
			key = "z",
			mods = "LEADER",
			action = wezterm.action.TogglePaneZoomState,
		},
		-- Prompt for a name to use for a new workspace and switch to it.
		{
			key = "N",
			mods = "LEADER",
			action = wezterm.action.PromptInputLine({
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
							wezterm.action.SwitchToWorkspace({
								name = line,
							}),
							pane
						)
					end
				end),
			}),
		},
		-- Create a new workspace with a random name and switch to it
		{ key = "n", mods = "LEADER", action = wezterm.action.SwitchToWorkspace },

		-- Show the launcher in fuzzy selection mode and have it list all workspaces
		-- and allow activating one.
		{
			key = "f",
			mods = "LEADER",
			action = wezterm.action.ShowLauncherArgs({
				flags = "FUZZY|WORKSPACES",
			}),
		},

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

		{
			key = "S",
			mods = "LEADER",
			action = wezterm.action_callback(function(win, pane)
				resurrect.save_state(resurrect.workspace_state.get_workspace_state())
				resurrect.window_state.save_window_action()
			end),
		},
		{
			key = "R",
			mods = "LEADER",
			action = wezterm.action_callback(function(win, pane)
				resurrect.fuzzy_load(win, pane, function(id, label)
					local type = string.match(id, "^([^/]+)") -- match before '/'
					id = string.match(id, "([^/]+)$") -- match after '/'
					id = string.match(id, "(.+)%..+$") -- remove file extention
					local opts = {
						relative = true,
						restore_text = true,
						on_pane_restore = resurrect.tab_state.default_on_pane_restore,
					}
					if type == "workspace" then
						local state = resurrect.load_state(id, "workspace")
						resurrect.workspace_state.restore_workspace(state, opts)
					elseif type == "window" then
						local state = resurrect.load_state(id, "window")
						resurrect.window_state.restore_window(pane:window(), state, opts)
					elseif type == "tab" then
						local state = resurrect.load_state(id, "tab")
						resurrect.tab_state.restore_tab(pane:tab(), state, opts)
					end
				end)
			end),
		},
		{
			key = "D",
			mods = "LEADER",
			action = wezterm.action_callback(function(win, pane)
				resurrect.fuzzy_load(win, pane, function(id)
					resurrect.delete_state(id)
				end, {
					title = "Delete State",
					description = "Select State to Delete and press Enter = accept, Esc = cancel, / = filter",
					fuzzy_description = "Search State to Delete: ",
					is_fuzzy = true,
				})
			end),
		},
	}

	keycher.apply_keys(config.keys, keys)
end

return M
