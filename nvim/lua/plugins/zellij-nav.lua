return {
	"https://git.sr.ht/~swaits/zellij-nav.nvim",
	lazy = true,
	event = "VeryLazy",
	keys = {
		{ "<C-h>", "<cmd>ZellijNavigateLeft<cr>", { silent = true, desc = "navigate left" } },
		{ "<C-j>", "<cmd>ZellijNavigateDown<cr>", { silent = true, desc = "navigate down" } },
		{ "<C-k>", "<cmd>ZellijNavigateUp<cr>", { silent = true, desc = "navigate up" } },
		{ "<C-l>", "<cmd>ZellijNavigateRight<cr>", { silent = true, desc = "navigate right" } },
	},
	opts = {},
}
