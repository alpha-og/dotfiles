local config = function()
	local lspconfig = require("lspconfig")
	-- Reserve a space in the gutter
	-- This will avoid an annoying layout shift in the screen
	vim.opt.signcolumn = "yes"

	-- Add cmp_nvim_lsp capabilities settings to lspconfig
	-- This should be executed before you configure any language server
	local lspconfig_defaults = require("lspconfig").util.default_config
	lspconfig_defaults.capabilities =
		vim.tbl_deep_extend("force", lspconfig_defaults.capabilities, require("cmp_nvim_lsp").default_capabilities())

	-- This is where you enable features that only work
	-- if there is a language server active in the file
	vim.api.nvim_create_autocmd("LspAttach", {
		desc = "LSP actions",
		callback = function(event)
			local opts = { buffer = event.buf }

			vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", opts)
			vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
			vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)
			vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", opts)
			vim.keymap.set("n", "go", "<cmd>lua vim.lsp.buf.type_definition()<cr>", opts)
			vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", opts)
			vim.keymap.set("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)
			vim.keymap.set("n", "<F2>", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
			vim.keymap.set({ "n", "x" }, "<F3>", "<cmd>lua vim.lsp.buf.format({async = true})<cr>", opts)
			vim.keymap.set("n", "<F4>", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
		end,
	})

	-- Change the Diagnostic symbols in the sign column (gutter)
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
	-- lspconfig.gopls.setup({
	-- 	capabilities = capabilities,
	-- 	on_attach = on_attach,
	-- })

	local luacheck = require("efmls-configs.linters.luacheck")
	local stylua = require("efmls-configs.formatters.stylua")
	local flake8 = require("efmls-configs.linters.flake8")
	local black = require("efmls-configs.formatters.black")
	local eslint_d = require("efmls-configs.linters.eslint_d")
	local prettier_d = require("efmls-configs.formatters.prettier_d")
	-- local fixjson = require("efmls-configs.formatters.fixjson")
	local shellcheck = require("efmls-configs.linters.shellcheck")
	local shfmt = require("efmls-configs.formatters.shfmt")
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
			"markdown",
			"mdx",
			"docker",
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
				go = { { formatCommand = "gofmt", formatStdin = true } },
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
	},
	config = config,
}
