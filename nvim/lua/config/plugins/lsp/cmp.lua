local config = function()
	local cmp = require("cmp")
	local luasnip = require("luasnip")
	local lspkind = require("lspkind")

	require("luasnip/loaders/from_vscode").lazy_load()

	vim.opt.completeopt = "menu,menuone,preview,noselect"

	cmp.setup({
		mapping = cmp.mapping.preset.insert({
			["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }), -- previous suggestion
			["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }), -- next suggestion
			["<C-b>"] = cmp.mapping.scroll_docs(-4),
			["<C-f>"] = cmp.mapping.scroll_docs(4),
			["<C-Space>"] = cmp.mapping.complete(), -- show completion suggestions
			["<C-c>"] = cmp.mapping.abort(), -- close completion window
			["<CR>"] = cmp.mapping(
				cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
				{ "i", "c" }
			), -- confirm completion
		}),
		-- sources for autocompletion in order of preference
		sources = {
			{ name = "nvim_lsp" }, -- lsp
			{ name = "luasnip" }, -- snippets
			{ name = "path" }, -- file system paths
			{ name = "crates" }, -- crates.io
			{ name = "buffer" }, -- text within current buffer
		},
		-- configure lspkind for vs-code like icons
		snippet = {
			expand = function(args)
				luasnip.lsp_expand(args.body)
			end,
		},
		formatting = {
			format = lspkind.cmp_format({
				mode = "symbol",
				maxwidth = 50,
				-- symbol_map = {
				-- 	Supermaven = " ",
				-- },
				ellipsis_char = "...",
			}),
		},
	})
end

return {
	"hrsh7th/nvim-cmp",
	event = "InsertEnter",
	config = config,
	dependencies = {
		{

			"L3MON4D3/LuaSnip", -- snippet engine
			-- follow latest release.
			version = "2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
			-- install jsregexp (optional!).
			build = "make install_jsregexp",
		},
		"onsails/lspkind.nvim", -- lsp kind icons
		"hrsh7th/cmp-buffer", -- source for text in buffer
		"hrsh7th/cmp-path", -- source for file system paths
		"saadparwaiz1/cmp_luasnip", -- autocompletion
		"rafamadriz/friendly-snippets", -- snippets
	},
}
