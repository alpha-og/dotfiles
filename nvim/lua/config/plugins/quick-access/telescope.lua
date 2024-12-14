local config = function()
	local telescope = require("telescope")
	local actions = require("telescope.actions")
	telescope.setup({
		pickers = {
			find_files = {
				theme = "dropdown",
				previewer = true,
				hidden = true, -- toggle hidden files from appearing in telescope file search
			},
			live_grep = {
				theme = "dropdown",
				previewer = true,
			},
			buffers = {
				theme = "dropdown",
				previewer = true,
			},
		},
	})

	telescope.load_extension("fzf")
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
	keys = {
		{ "<leader>ff", "<CMD>Telescope find_files<CR>", desc = "Find files" },
		{ "<leader>fg", "<CMD>Telescope live_grep<CR>", desc = "Grep search" },
		{ "<leader>fb", "<CMD>Telescope buffers<CR>", desc = "Find buffers" },
	},
}
