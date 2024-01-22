local mapkey = require("utils/keymapper").mapvimkey
return {
	"nvimdev/lspsaga.nvim",
	dependencies = {
		"nvim-treesitter/nvim-treesitter", -- optional
		"nvim-tree/nvim-web-devicons", -- optional
	},
	event = "LspAttach",
	config = true,
}
