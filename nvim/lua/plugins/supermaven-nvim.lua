return {
	"supermaven-inc/supermaven-nvim",
	commit = "d7125",
	lazy = false,
	config = function()
		require("supermaven-nvim").setup({
			keymaps = {
				accept_suggestion = "<C-l>",
				clear_suggestion = "<C-]>",
				accept_word = "<C-m>",
			},
			-- disable_inline_completion = true,
			-- 	ignore_filetypes = {
			-- 		rust = true,
			-- 		-- c = true,
			-- 	},
		})
	end,
}
