local config = function()
	local telescope = require("telescope")
	local actions = require("telescope.actions")
	telescope.setup({
		defaults = {
			mappings = {
				i = {
					["<C-j>"] = "move_selection_next",
					["<C-k>"] = "move_selection_previous",
				},
			},
		},
		pickers = {
			find_files = {
				-- theme = "dropdown",
				previewer = true,
				hidden = true, -- toggle hidden files from appearing in telescope file search
			},
			live_grep = {
				-- theme = "dropdown",
				previewer = true,
			},
			buffers = {
				-- theme = "dropdown",
				previewer = true,
			},
		},
	})

	telescope.load_extension("fzf")

	vim.keymap.set(
		"n",
		"<leader>fk",
		"<CMD>Telescope keymaps<CR>",
		{ noremap = true, silent = true, desc = "Show Keymaps" }
	)
	vim.keymap.set(
		"n",
		"<leader>fh",
		"<CMD>Telescope help_tags<CR>",
		{ noremap = true, silent = true, desc = "Show Help Tags" }
	)
	vim.keymap.set(
		"n",
		"<leader>ff",
		"<CMD>Telescope find_files<CR>",
		{ noremap = true, silent = true, desc = "Find Files" }
	)
	vim.keymap.set(
		"n",
		"<leader>fg",
		"<CMD>Telescope live_grep<CR>",
		{ noremap = true, silent = true, desc = "Live Grep" }
	)
	vim.keymap.set(
		"n",
		"<leader>fb",
		"<CMD>Telescope buffers<CR>",
		{ noremap = true, silent = true, desc = "Find Buffers" }
	)
end

return {
	"nvim-telescope/telescope.nvim",
	tag = "0.1.3",
	lazy = false,
	dependencies = {
		"nvim-lua/plenary.nvim",
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make",
		},
		"nvim-tree/nvim-web-devicons",
	},
	config = config,
	keys = {},
}
