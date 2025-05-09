-- plugin for using and navigating terminals

return {
	"alpha-og/terminotaur",
	config = function()
		vim.keymap.set("n", "<leader>tt", "<cmd>ToggleFloatingTerminal<cr>", { noremap = true, silent = true })
		vim.keymap.set("n", "<leader>tv", "<cmd>OpenNewVerticalTerminal<cr>", { noremap = true, silent = true })
		vim.keymap.set("n", "<leader>th", "<cmd>OpenNewHorizontalTerminal<cr>", { noremap = true, silent = true })
		vim.keymap.set("t", "<esc><esc>", "<C-\\><C-n>", { noremap = true, silent = true })
		vim.keymap.set("t", "<C-[><C-[>", "<C-\\><C-n>", { noremap = true, silent = true })
	end,
}
