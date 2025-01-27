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

	-- set keymaps
	local builtin = require("telescope.builtin")
	local opts = { noremap = true, silent = true }
	local keymap = vim.keymap
	opts.desc = "help tags"
	keymap.set("n", "<leader>fh", builtin.help_tags, opts)

	opts.desc = "find files"
	keymap.set("n", "<leader>ff", builtin.find_files, opts)

	opts.desc = "live grep"
	keymap.set("n", "<leader>fg", builtin.live_grep, opts)

	opts.desc = "buffers"
	keymap.set("n", "<leader>fb", builtin.buffers, opts)

	opts.desc = "lazy plugins"
	keymap.set("n", "<leader>lp", "<CMD>Telescope lazy_plugins<CR>", opts)

	-- neorg telescope mappings
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
		"nvim-neorg/neorg-telescope",
	},
	config = config,
	-- keys = {
	-- 	{ "<leader>fh", "Telescope help_tags", desc = "Help tags" },
	-- 	{ "<leader>ff", "Telescope find_files", desc = "Find files" },
	-- 	{ "<leader>fg", "Telescope live_grep", desc = "Live grep" },
	-- 	{ "<leader>fb", "Telescope buffers", desc = "Buffers" },
	-- 	{ "<leader>lp", "<CMD>Telescope lazy_plugins<CR>", desc = "Lazy plugins" },
	-- }
}
