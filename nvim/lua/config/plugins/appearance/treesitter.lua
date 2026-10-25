-- provides highlighting for available languages

local ensure_installed = {
	-- languages
	"rust",
	"wgsl",
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
	-- local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
	-- parser_config.embedded_template = {
	-- 	install_info = {
	-- 		url = "https://github.com/tree-sitter/tree-sitter-embedded-template",
	-- 		files = { "src/parser.c" },
	-- 		requires_generate_from_grammar = true,
	-- 	},
	-- 	filetype = "ejs",
	-- }

	require("nvim-treesitter").install(ensure_installed)
	vim.api.nvim_create_autocmd("FileType", {
		callback = function(args)
			-- Attempt to start treesitter highlighting for the current buffer
			pcall(vim.treesitter.start, args.buf)
		end,
	})
end

return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	build = ":TSUpdate",
	config = config,
}
