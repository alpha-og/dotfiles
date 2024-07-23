return {
	"declancm/maximize.nvim",
	lazy = false,
	config = function()
		require("maximize").setup()
		vim.keymap.set("n", "<leader>mm", "<cmd>Maximize<cr>", { desc = "Maximize", silent = true, noremap = true })
	end,
}
