local wezterm = require("wezterm")
local background = require("background")
local keymaps = require("keymaps")

local config = wezterm.config_builder()
local function basename(s)
	return string.gsub(s, "(.*[/\\])(.*)", "%2")
end

config.leader = keymaps.leader
config.keys = {}

-- font
config.font = wezterm.font("Hack Nerd Font")
config.font_size = 15

-- appearance
config.color_scheme = "Catppuccin Mocha" -- set color scheme
config.hide_tab_bar_if_only_one_tab = true -- hide tab bar if there is only one tab
-- config.window_background_image = constants.bg -- set background image
config.background = background.catppuccin.image.clearday -- set background image

config.window_decorations = "RESIZE" -- disable title bar
config.window_padding = {
	bottom = 0,
} -- remove bottom padding on the window
config.use_resize_increments = true
config.use_fancy_tab_bar = false

-- performance
-- config.max_fps = 120 -- set max fps to 120
-- config.prefer_egl = true -- prefer egl

local resurrect = wezterm.plugin.require("https://github.com/MLFlexer/resurrect.wezterm")
---@param opts? { interval_seconds: integer?, save_workspaces: boolean?, save_windows: boolean?, save_tabs: boolean? }
resurrect.periodic_save({ interval_seconds = 60, save_workspaces = true, save_windows = true, save_tabs = true })

local workspace_switcher = wezterm.plugin.require("https://github.com/MLFlexer/smart_workspace_switcher.wezterm")
workspace_switcher.workspace_formatter = function(label)
	return wezterm.format({
		{ Attribute = { Italic = true } },
		-- { Foreground = { Color = colors.colors.ansi[3] } },
		-- { Background = { Color = colors.colors.background } },
		{ Text = "󱂬 : " .. label },
	})
end

wezterm.on("smart_workspace_switcher.workspace_switcher.created", function(window, path, label)
	window:gui_window():set_right_status(wezterm.format({
		{ Attribute = { Intensity = "Bold" } },
		-- { Foreground = { Color = colors.colors.ansi[5] } },
		{ Text = basename(path) .. "  " },
	}))
	local workspace_state = resurrect.workspace_state

	workspace_state.restore_workspace(resurrect.load_state(label, "workspace"), {
		window = window,
		relative = true,
		restore_text = true,
		on_pane_restore = resurrect.tab_state.default_on_pane_restore,
	})
end)

wezterm.on("smart_workspace_switcher.workspace_switcher.chosen", function(window, path, label)
	wezterm.log_info(window)
	window:gui_window():set_right_status(wezterm.format({
		{ Attribute = { Intensity = "Bold" } },
		-- { Foreground = { Color = colors.colors.ansi[5] } },
		{ Text = basename(path) .. "  " },
	}))
end)

wezterm.on("smart_workspace_switcher.workspace_switcher.selected", function(window, path, label)
	wezterm.log_info(window)
	local workspace_state = resurrect.workspace_state
	resurrect.save_state(workspace_state.get_workspace_state())
	resurrect.write_current_state(label, "workspace")
end)

wezterm.on("smart_workspace_switcher.workspace_switcher.start", function(window, _)
	wezterm.log_info(window)
end)
wezterm.on("smart_workspace_switcher.workspace_switcher.canceled", function(window, _)
	wezterm.log_info(window)
end)
wezterm.on("gui-startup", resurrect.resurrect_on_gui_startup)

keymaps.setup(wezterm, config)

-- return the configuration
return config
