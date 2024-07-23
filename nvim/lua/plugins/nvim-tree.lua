local config = function()
	local nvim_tree = require("nvim-tree")
	nvim_tree.setup({
		filters = {
			dotfiles = false,
		},
		view = {
			width = 30,
			adaptive_size = true,
		},
	})

	local set_keymap = vim.keymap.set

	set_keymap("n", "<leader>ee", ":NvimTreeToggle<CR>")
	set_keymap("n", "<leader>ef", ":NvimTreeFocus<CR>")
	set_keymap("n", "<leader>er", ":NvimTreeRefresh<CR>")
end

return {
	"nvim-tree/nvim-tree.lua",
	lazy = false,
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	config = config,
}
