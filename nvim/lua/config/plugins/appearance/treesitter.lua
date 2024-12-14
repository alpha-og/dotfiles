-- provides highlighting for available languages
local ensure_installed = {
	-- languages
	"rust",
	"cpp",
	"c",
	"javascript",
	"typescript",
	"python",
	"java",
	"html",
	"css",
	"lua",
	"bash",
	"vim",
	-- data formats
	"markdown",
	"json",
	"yaml",
	"toml",
	-- frameworks
	"astro",
	-- misc
	"xml",
	"dockerfile",
	"http",
    -- vim help
    "vimdoc",
}
local config = function()
	require("nvim-treesitter.configs").setup({
	ensure_installed = ensure_installed,
		auto_install = true,
		highlight = {
			enable = true,
			additional_vim_regex_highlighting = false,
		},
		incremental_selection = {
			enable = true,
			keymaps = {
				init_selection = "<C-s>",
				node_incremental = "<C-s>",
				scope_incremental = false,
				node_decremental = "<BS>",
			},
		},
	})
end


return {
	"nvim-treesitter/nvim-treesitter",
    config = config,
}
