local wezterm = require("wezterm")
local background = require("background")
local keymaps = require("keymaps")
require("plugins.plugins")

local config = wezterm.config_builder()

config.leader = keymaps.leader
config.keys = keymaps.keys

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

-- return the configuration
return config
