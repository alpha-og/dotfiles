local mapvimkey = require("utils.keymapper").mapvimkey

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
				hidden = true,
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

	mapvimkey("n", "<leader>fk", "Telescope keymaps", {desc = "Show Keymaps"})
    mapvimkey("n", "<leader>fh", "Telescope help_tags", {desc = "Show Help Tags"})
	mapvimkey("n", "<leader>ff", "Telescope find_files", {desc = "Find Files"})
	mapvimkey("n", "<leader>fg", "Telescope live_grep", {desc ="Live Grep"})
	mapvimkey("n", "<leader>fb", "Telescope buffers", {desc = "Find Buffers"})

end

return {
	"nvim-telescope/telescope.nvim",
	tag = "0.1.3",
	lazy = false,
	dependencies = { 
        "nvim-lua/plenary.nvim",
        {
            "nvim-telescope/telescope-fzf-native.nvim",
            build="make"
        },
        "nvim-tree/nvim-web-devicons",
    },
	config = config,
	keys = {
	},
}
