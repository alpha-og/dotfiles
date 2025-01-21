-- Pull in the wezterm API
local wezterm = require("wezterm")
local action = wezterm.action

-- auto update plugins
wezterm.plugin.update_all()

-- variable to hold the configuration
local config = wezterm.config_builder()
local keys = config.keys or {}
local key_tables = config.key_tables or {}

-- workspace switcher plugin
local workspace_switcher = wezterm.plugin.require("https://github.com/MLFlexer/smart_workspace_switcher.wezterm")
wezterm.on("smart_workspace_switcher.workspace_switcher.chosen", function(window, workspace)
	local gui_win = window:gui_window()
	local base_path = string.gsub(workspace, "(.*[/\\])(.*)", "%2")
	gui_win:set_right_status(wezterm.format({
		{ Foreground = { Color = "green" } },
		{ Text = base_path .. "  " },
	}))
end)

wezterm.on("smart_workspace_switcher.workspace_switcher.created", function(window, workspace)
	local gui_win = window:gui_window()
	local base_path = string.gsub(workspace, "(.*[/\\])(.*)", "%2")
	gui_win:set_right_status(wezterm.format({
		{ Foreground = { Color = "green" } },
		{ Text = base_path .. "  " },
	}))
end)

-- udpate the right status bar
-- wezterm.on("update-right-status", function(window, pane)
-- 	window:set_right_status(window:active_workspace())
-- end)

wezterm.on("update-right-status", function(window, pane)
	local name = window:active_key_table()
	if name then
		name = "TABLE: " .. name
	end
	window:set_right_status(name or "")
end)
-- create a new workspace with a random name
table.insert(keys, { key = "r", mods = "LEADER", action = wezterm.action.SwitchToWorkspace })
-- Prompt for a name to use for a new workspace and switch to it.
table.insert(keys, {
	key = "n",
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
})
-- open workspace switcher
table.insert(keys, {
	key = "W",
	mods = "LEADER",
	action = workspace_switcher.switch_workspace(),
})
-- switch to previous workspace
table.insert(keys, {
	key = "w",
	mods = "LEADER",
	action = workspace_switcher.switch_to_prev_workspace(),
})

-- resurrect plugin
local resurrect = wezterm.plugin.require("https://github.com/MLFlexer/resurrect.wezterm")

-- save workspace state
table.insert(keys, {
	key = "w",
	mods = "ALT",
	action = wezterm.action_callback(function(win, pane)
		resurrect.save_state(resurrect.workspace_state.get_workspace_state())
	end),
})

-- save window state
table.insert(keys, {
	key = "W",
	mods = "ALT",
	action = resurrect.window_state.save_window_action(),
})

-- save tab state
table.insert(keys, {
	key = "T",
	mods = "ALT",
	action = resurrect.tab_state.save_tab_action(),
})

-- save workspace and window state
table.insert(keys, {
	key = "s",
	mods = "ALT",
	action = wezterm.action_callback(function(win, pane)
		resurrect.save_state(resurrect.workspace_state.get_workspace_state())
		resurrect.window_state.save_window_action()
	end),
})

-- restore state via fuzzy finder
table.insert(keys, {
	key = "r",
	mods = "ALT",
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
})

-- delete state via fuzzy finder
table.insert(keys, {
	key = "d",
	mods = "ALT",
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
})
-- save state every 5 minutes
resurrect.periodic_save({
	interval_seconds = 60,
	save_workspaces = true,
	save_windows = true,
	save_tabs = true,
})

-- restores state when wezterm starts
wezterm.on("gui-startup", resurrect.resurrect_on_gui_startup)

-- loads the state whenever I create a new workspace
wezterm.on("smart_workspace_switcher.workspace_switcher.created", function(window, path, label)
	local workspace_state = resurrect.workspace_state

	workspace_state.restore_workspace(resurrect.load_state(label, "workspace"), {
		window = window,
		relative = true,
		restore_text = true,
		on_pane_restore = resurrect.tab_state.default_on_pane_restore,
	})
end)

-- Saves the state whenever I select a workspace
wezterm.on("smart_workspace_switcher.workspace_switcher.selected", function(window, path, label)
	local workspace_state = resurrect.workspace_state
	resurrect.save_state(workspace_state.get_workspace_state())
end)

-- augment the command palette with ressurect
wezterm.on("augment-command-palette", function(window, pane)
	local workspace_state = resurrect.workspace_state
	return {
		{
			brief = "Window | Workspace: Switch Workspace",
			icon = "md_briefcase_arrow_up_down",
			action = workspace_switcher.switch_workspace(),
		},
		{
			brief = "Window | Workspace: Rename Workspace",
			icon = "md_briefcase_edit",
			action = wezterm.action.PromptInputLine({
				description = "Enter new name for workspace",
				action = wezterm.action_callback(function(window, pane, line)
					if line then
						wezterm.mux.rename_workspace(wezterm.mux.get_active_workspace(), line)
						resurrect.save_state(workspace_state.get_workspace_state())
					end
				end),
			}),
		},
	}
end)

-- custom pain control
local pane_resize = 5

local pain_keys = {
	-- Navigation
	{ key = "h", mods = "LEADER", action = action.ActivatePaneDirection("Left") },
	{ key = "h", mods = "LEADER|CTRL", action = action.ActivatePaneDirection("Left") },
	{ key = "j", mods = "LEADER", action = action.ActivatePaneDirection("Down") },
	{ key = "j", mods = "LEADER|CTRL", action = action.ActivatePaneDirection("Down") },
	{ key = "k", mods = "LEADER", action = action.ActivatePaneDirection("Up") },
	{ key = "k", mods = "LEADER|CTRL", action = action.ActivatePaneDirection("Up") },
	{ key = "l", mods = "LEADER", action = action.ActivatePaneDirection("Right") },
	{ key = "l", mods = "LEADER|CTRL", action = action.ActivatePaneDirection("Right") },

	-- Resizing Panes
	{
		key = "h",
		mods = "LEADER|SHIFT",
		action = action.Multiple({
			action.AdjustPaneSize({ "Left", pane_resize }),
			action.ActivateKeyTable({ name = "resize_pane", one_shot = false, until_unknown = true }),
		}),
	},
	{
		key = "j",
		mods = "LEADER|SHIFT",
		action = action.Multiple({
			action.AdjustPaneSize({ "Down", pane_resize }),
			action.ActivateKeyTable({ name = "resize_pane", one_shot = false, until_unknown = true }),
		}),
	},
	{
		key = "k",
		mods = "LEADER|SHIFT",
		action = action.Multiple({
			action.AdjustPaneSize({ "Up", pane_resize }),
			action.ActivateKeyTable({ name = "resize_pane", one_shot = false, until_unknown = true }),
		}),
	},
	{
		key = "l",
		mods = "LEADER|SHIFT",
		action = action.Multiple({
			action.AdjustPaneSize({ "Right", pane_resize }),
			action.ActivateKeyTable({ name = "resize_pane", one_shot = false, until_unknown = true }),
		}),
	},

	-- Splitting Panes
	{ key = "v", mods = "LEADER", action = action.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "s", mods = "LEADER", action = action.SplitVertical({ domain = "CurrentPaneDomain" }) },

	-- Swapping Windows
	{ key = "<", mods = "LEADER|SHIFT", action = action.MoveTabRelative(-1) },
	{ key = ">", mods = "LEADER|SHIFT", action = action.MoveTabRelative(1) },
}

for _, key in ipairs(pain_keys) do
	table.insert(keys, key)
end

if not config.key_tables then
	config.key_tables = {}
end

config.key_tables.resize_pane = {
	{ key = "h", mods = "SHIFT", action = action.AdjustPaneSize({ "Left", pane_resize }) },
	{ key = "j", mods = "SHIFT", action = action.AdjustPaneSize({ "Down", pane_resize }) },
	{ key = "k", mods = "SHIFT", action = action.AdjustPaneSize({ "Up", pane_resize }) },
	{ key = "l", mods = "SHIFT", action = action.AdjustPaneSize({ "Right", pane_resize }) },
	{ key = "Escape", action = action.PopKeyTable },
}

-- general keymaps
config.leader = { key = ";", mods = "CTRL", timeout_milliseconds = 1000 } -- leader key

-- disable the default keybinding for alt-enter
table.insert(keys, {
	key = "Enter",
	mods = "ALT",
	action = wezterm.action.DisableDefaultAssignment,
})

-- font
config.font = wezterm.font("Hack Nerd Font")
config.font_size = 15

-- theme
config.color_scheme = "Catppuccin Mocha"

-- set max fps to 120
config.max_fps = 120

-- disable tab bar
config.enable_tab_bar = false

-- disable title bar
config.window_decorations = "RESIZE"

-- window background
config.window_background_opacity = 0.85
config.macos_window_background_blur = 25

-- set the default program
-- config.default_prog = { "zellij", "-l", "welcome" }

-- disable window close confirmation
config.window_close_confirmation = "NeverPrompt"

-- remove bottom padding on the window
config.window_padding = {
	bottom = 0,
}

config.key_tables = key_tables
config.keys = keys

config.use_resize_increments = true

-- return the configuration
return config
