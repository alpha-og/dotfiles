-- fuzzy finder over lists

local config = function()
	local telescope = require("telescope")
	telescope.setup({
		pickers = {
			find_files = {
				previewer = true,
				hidden = true, -- toggle hidden files from appearing in telescope file search
			},
			live_grep = {
				previewer = true,
			},
			buffers = {
				previewer = true,
			},
		},
		extensions = {
			fzf = {
				fuzzy = true, -- false will only do exact matching
				override_generic_sorter = true, -- override the generic sorter
				override_file_sorter = true, -- override the file sorter
				case_mode = "smart_case", -- or "ignore_case" or "respect_case"
			},
			noice = {},
            lazy_plugins = {},
		},
	})

	-- load extensions
	telescope.load_extension("fzf")
	telescope.load_extension("noice")
    telescope.load_extension("lazy_plugins")
end

return {
	"nvim-telescope/telescope.nvim",
	tag = "0.1.8",
	lazy = false,
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"folke/noice.nvim",
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make",
		},
		"polirritmico/telescope-lazy-plugins.nvim",
	},
	config = config,
	keys = {
		{ "<leader>fh", require("telescope.builtin").help_tags, desc = "Help tags" },
		{ "<leader>ff", require("telescope.builtin").find_files, desc = "Find files" },
		{ "<leader>fg", require("telescope.builtin").live_grep, desc = "Grep search" },
		{ "<leader>fb", require("telescope.builtin").buffers, desc = "Find buffers" },
        { "<leader>tp", "<CMD>Telescope lazy_plugins<CR>", desc = "Lazy plugins" },
	},
}
