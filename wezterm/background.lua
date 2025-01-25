local M = {}
local colors = require("colors")

M.catppuccin = { blurred_image = {}, simple = {}, image = {} }

M.catppuccin.simple = {
	{
		source = {
			Color = colors.text,
		},
		width = "100%",
		height = "100%",
		hsb = {
			brightness = 1,
		},
	},
	{
		source = {
			Gradient = {
				colors = {
					colors.mauve,
					colors.lavender,
				},
				orientation = "Vertical",
			},
		},
		width = "100%",
		height = "100%",
		hsb = {
			brightness = 0.025,
		},
		opacity = 0.9,
	},
}

M.catppuccin.blurred_image.flower = {
	{
		source = {
			Color = colors.text,
		},
		width = "100%",
		height = "100%",
		hsb = {
			brightness = 1,
		},
	},
	{
		source = {
			Gradient = {
				colors = {
					colors.mauve,
					colors.lavender,
				},
				orientation = "Vertical",
			},
		},
		width = "100%",
		height = "100%",
		hsb = {
			brightness = 0.025,
		},
		opacity = 0.9,
	},
	{
		source = {
			File = "/Users/athulanoop/dotfiles/wezterm/assets/abstract_flower_bg_blurred.jpg",
		},
		hsb = {
			brightness = 0.2,
		},
		opacity = 0.5,
	},
}

M.catppuccin.image.clearday = {
	{
		source = {
			File = "/Users/athulanoop/dotfiles/wezterm/assets/clearday.jpg",
		},
	},
	{
		source = {
			Color = colors.text,
		},
		width = "100%",
		height = "100%",
		hsb = {
			brightness = 1,
		},
		opacity = 0.4,
	},

	{
		source = {
			Gradient = {
				colors = {
					colors.mauve,
					colors.lavender,
				},
				orientation = "Vertical",
			},
		},
		width = "100%",
		height = "100%",
		hsb = {
			brightness = 0.02,
		},
		opacity = 0.9,
	},
}

M.blurred_image = {
	flower = {
		{
			source = {
				File = "/Users/athulanoop/dotfiles/wezterm/assets/abstract_flower_bg_blurred.jpg",
			},
			hsb = {
				brightness = 0.5,
			},
		},
	},
}

M.image = {
	clearday = {
		{
			source = {
				File = "/Users/athulanoop/dotfiles/wezterm/assets/clearday.jpg",
			},
			hsb = {
				brightness = 0.5,
			},
		},
	},
}

return M
