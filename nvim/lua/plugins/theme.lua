return {
	"catppuccin/nvim",
	name = "catppuccin",
	lazy = false,
	priority = 999,
	config = function()
		require("catppuccin").setup({
			transparent_background = true,
		})

		vim.cmd("colorscheme catppuccin")
	end,
}
