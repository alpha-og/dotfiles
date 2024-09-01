-- Pull in the wezterm API
local wezterm = require("wezterm")

-- variable to hold the configuration
local config = wezterm.config_builder()

-- font
config.font = wezterm.font("Hack Nerd Font")
config.font_size = 13

-- theme
config.color_scheme = "Catppuccin Mocha"

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
-- return the configuration
return config
