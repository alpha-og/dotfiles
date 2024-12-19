-- plugin for showing notifications

return {
	"rcarriga/nvim-notify",
	config = function()
		require("notify").setup({
			background_colour = "#000000",
			timeout = 500,
			render = "compact",
		})

		vim.keymap.set(
			"n",
			"<leader>vn",
			"<CMD>Telescope notify<CR>",
			{ noremap = true, silent = true, desc = "View Notification History" }
		)
		vim.keymap.set(
			"n",
			"<leader>cn",
			require("notify").dismiss,
			{ noremap = true, silent = true, desc = "Dismiss Notification" }
		)
	end,
}
