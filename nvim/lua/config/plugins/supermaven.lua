return {
	"supermaven-inc/supermaven-nvim",
	commit = "d7125",
	config = function()
		require("supermaven-nvim").setup({
			keymaps = {
				accept_suggestion = "<C-l>",
				clear_suggestion = "<C-]>",
				accept_word = "<C-m>",
			},
		})
	end,
}
