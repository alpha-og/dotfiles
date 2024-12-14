-- plugin for catppucin theme
return {
	"catppuccin/nvim",
	name="catppuccin",
	priority=999,
	config=function()
		require("catppuccin").setup({
			transparent_background=true,
		})
		vim.cmd("colorscheme catppuccin")
	end
}
