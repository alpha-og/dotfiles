local M = {}

M.colors = {
	rosewater = "#DC8A78",
	flamingo = "#DD7878",
	pink = "#EA76CB",
	mauve = "#8839EF",
	red = "#D20F39",
	maroon = "#E64553",
	peach = "#FE640B",
	yellow = "#DF8E1D",
	green = "#40A02B",
	teal = "#179299",
	sky = "#04A5E5",
	sapphire = "#209FB5",
	blue = "#1E66F5",
	lavender = "#7287FD",
	text = "#4C4F69",
	subtext1 = "#5C5F77",
	subtext0 = "#6C6F85",
	overlay2 = "#7C7F93",
	overlay1 = "#8C8FA1",
	overlay0 = "#9CA0B0",
	surface2 = "#ACB0BE",
	surface1 = "#BCC0CC",
	surface0 = "#CCD0DA",
	base = "#EFF1F5",
	mantle = "#E6E9EF",
	crust = "#DCE0E8",
}

M.catppuccin = { blurred_image = {}, simple = {}, image = {} }

M.catppuccin.simple = {
	{
		source = {
			Color = M.colors.text,
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
					M.colors.mauve,
					M.colors.lavender,
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
			Color = M.colors.text,
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
					M.colors.mauve,
					M.colors.lavender,
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
			Color = M.colors.text,
		},
		width = "100%",
		height = "100%",
		hsb = {
			brightness = 1,
		},
	},
	{
		source = {
			File = "/Users/athulanoop/dotfiles/wezterm/assets/clearday.jpg",
		},
	},
	{
		source = {
			Gradient = {
				colors = {
					M.colors.mauve,
					M.colors.lavender,
				},
				orientation = "Vertical",
			},
		},
		width = "100%",
		height = "100%",
		hsb = {
			brightness = 0.025,
		},
		opacity = 0.93,
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
	landscape = {
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
