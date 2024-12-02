local config = function()
	local lspconfig = require("lspconfig")
	local cmp_nvim_lsp = require("cmp_nvim_lsp")
	local on_attach = require("utils.lsp").on_attach
	-- used to enable autocompletion (assign to every lsp server config)
	local capabilities = cmp_nvim_lsp.default_capabilities()

	-- Change the Diagnostic symbols in the sign column (gutter)
	-- (not in youtube nvim video)
	local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
	for type, icon in pairs(signs) do
		local hl = "DiagnosticSign" .. type
		vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
	end
	-- biome
	-- lspconfig.biome.setup({
	-- 	capabilities = capabilities,
	-- 	on_attach = on_attach,
	-- })

	-- tailwind
	lspconfig.tailwindcss.setup({})

	-- mdx and markdown
	lspconfig.marksman.setup({
		capabilities = capabilities,
		on_attach = on_attach,
		filetypes = { "mdx", "markdown" },
	})
	-- lua
	lspconfig.lua_ls.setup({
		capabilities = capabilities,
		on_attach = on_attach,
		settings = { -- custom settings for lua
			Lua = {
				-- make the language server recognize "vim" global
				diagnostics = {
					globals = { "vim" },
				},
				workspace = {
					-- make language server aware of runtime files
					library = {
						[vim.fn.expand("$VIMRUNTIME/lua")] = true,
						[vim.fn.stdpath("config") .. "/lua"] = true,
					},
				},
			},
		},
	})

	-- json
	lspconfig.jsonls.setup({
		capabilities = capabilities,
		on_attach = on_attach,
		filetypes = { "json", "jsonc" },
	})

	-- python
	lspconfig.pyright.setup({
		capabilities = capabilities,
		on_attach = on_attach,
		settings = {
			pyright = {
				disableOrganizeImports = false,
				analysis = {
					useLibraryCodeForTypes = true,
					autoSearchPaths = true,
					diagnosticMode = "workspace",
					autoImportCompletions = true,
				},
			},
		},
	})

	-- lspconfig.ast_grep.setup({
	-- 	capabilities = capabilities,
	-- 	on_attach = on_attach,
	-- 	filetypes = { "c", "cpp" },
	-- })
	-- -- typescript
	lspconfig.ts_ls.setup({
		on_attach = on_attach,
		capabilities = capabilities,
		filetypes = {
			"typescript",
			"javascript",
			"typescriptreact",
			"javascriptreact",
		},
		root_dir = lspconfig.util.root_pattern("package.json", "tsconfig.json", ".git"),
	})
	lspconfig.eslint.setup({
		capabilities = capabilities,
		on_attach = on_attach,
	})

	-- bash
	lspconfig.bashls.setup({
		capabilities = capabilities,
		on_attach = on_attach,
		filetypes = { "sh", "aliasrc" },
	})

	-- typescriptreact, javascriptreact, css, sass, scss, less, svelte, vue
	lspconfig.emmet_ls.setup({
		capabilities = capabilities,
		on_attach = on_attach,
		filetypes = {
			"typescriptreact",
			"javascriptreact",
			"css",
			"sass",
			"scss",
			"less",
			"svelte",
			"vue",
			"html",
		},
	})

	-- C/C++
	lspconfig.clangd.setup({
		capabilities = capabilities,
		on_attach = on_attach,
	})

	-- astro
	lspconfig.astro.setup({
		capabilities = capabilities,
		on_attach = on_attach,
		filetypes = { "astro" },
	})

	-- rust
	lspconfig.rust_analyzer.setup({
		capabilities = capabilities,
		on_attach = on_attach,
		filetypes = { "rust" },
		settings = {
			["rust-analyzer"] = {
				features = "all",
			},
		},
	})

	-- java
	lspconfig.jdtls.setup({
		capabilities = capabilities,
		on_attach = on_attach,
		filetypes = { "java" },
		handlers = {
			["language/status"] = function(_, result)
				-- Print or whatever.
			end,
			["$/progress"] = function(_, result, ctx)
				-- disable progress updates.
			end,
		},
	})

	-- go
	lspconfig.gopls.setup({
		capabilities = capabilities,
		on_attach = on_attach,
	})

	local luacheck = require("efmls-configs.linters.luacheck")
	local stylua = require("efmls-configs.formatters.stylua")
	local flake8 = require("efmls-configs.linters.flake8")
	local black = require("efmls-configs.formatters.black")
	local eslint_d = require("efmls-configs.linters.eslint_d")
	local prettier_d = require("efmls-configs.formatters.prettier_d")
	-- local prettier= require("efmls-configs.formatters.prettier")
	-- local fixjson = require("efmls-configs.formatters.fixjson")
	local shellcheck = require("efmls-configs.linters.shellcheck")
	local shfmt = require("efmls-configs.formatters.shfmt")
	-- local ast_grep = require("efmls-configs.linters.ast_grep")
	-- local hadolint = require("efmls-configs.linters.hadolint")
	-- local solhint = require("efmls-configs.linters.solhint")
	-- local cpplint = require("efmls-configs.linters.cpplint")
	local clangformat = require("efmls-configs.formatters.clang_format")
	local alex = require("efmls-configs.linters.alex")
	-- configure efm server
	lspconfig.efm.setup({
		filetypes = {
			"lua",
			"python",
			"json",
			"jsonc",
			"sh",
			"javascript",
			"javascriptreact",
			"typescript",
			"typescriptreact",
			"svelte",
			-- "vue",
			"markdown",
			"mdx",
			"docker",
			-- "solidity",
			"html",
			"astro",
			"css",
			"rust",
			"java",
			"c",
			"cpp",
		},
		init_options = {
			documentFormatting = true,
			documentRangeFormatting = true,
			hover = true,
			documentSymbol = true,
			codeAction = true,
			completion = true,
		},
		settings = {
			languages = {
				lua = { luacheck, stylua },
				python = { flake8, black },
				json = { eslint_d, prettier_d },
				jsonc = { eslint_d, prettier_d },
				sh = { shellcheck, shfmt },
				typescript = { eslint_d, prettier_d },
				javascript = { eslint_d, prettier_d },
				javascriptreact = { eslint_d, prettier_d },
				typescriptreact = { eslint_d, prettier_d },
				svelte = { eslint_d, prettier_d },
				-- vue = { eslint, prettier_d },
				markdown = { alex, prettier_d },
				mdx = { alex, prettier_d },
				-- docker = { hadolint, prettier_d },
				-- solidity = { solhint },
				html = { prettier_d },
				css = { prettier_d },
				astro = { prettier_d },
				rust = { { formatCommand = "rustfmt --edition 2021 --emit=stdout", formatStdin = true } },
				java = {},
				c = { clangformat },
				cpp = { clangformat },
			},
		},
	})
end

return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"hrsh7th/nvim-cmp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-nvim-lsp",
		"williamboman/mason.nvim",
		"creativenull/efmls-configs-nvim",
		"windwp/nvim-autopairs",
		{
			"antosha417/nvim-lsp-file-operations",
			config = true,
		},
		{
			"nvim-java/nvim-java",
		},
	},
	config = config,
}
