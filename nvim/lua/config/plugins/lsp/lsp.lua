-- plugin configuration for handling neovim's native lsp

local create_lsp_keymaps = function()
	local telescope_builtin = require("telescope.builtin")
	vim.api.nvim_create_autocmd("LspAttach", {
		callback = function(event)
			local opts = { buffer = event.buf, noremap = true, silent = true }
			opts.desc = "Hover"
			vim.keymap.set("n", "K", function()
				vim.lsp.buf.hover()
			end, opts)
			opts.desc = "Go to Definition"
			-- vim.keymap.set("n", "gd", function()
			-- 	vim.lsp.buf.definition()
			-- end, opts)
			vim.keymap.set("n", "<leader>gd", telescope_builtin.lsp_definitions, opts)
			opts.desc = "Declaration"
			vim.keymap.set("n", "gD", function()
				vim.lsp.buf.declaration()
			end, opts)
			opts.desc = "Go to Implementation"
			-- vim.keymap.set("n", "gi", function()
			-- 	vim.lsp.buf.implementation()
			-- end, opts)
			vim.keymap.set("n", "<leader>gi", telescope_builtin.lsp_implementations, opts)
			opts.desc = "Go to Type Definition"
			-- vim.keymap.set("n", "go", function()
			-- 	vim.lsp.buf.type_definition()
			-- end, opts)
			vim.keymap.set("n", "<leader>gt", telescope_builtin.lsp_type_definitions, opts)
			opts.desc = "List LSP references for the word under the cursor"
			-- vim.keymap.set("n", "gr", function()
			-- 	vim.lsp.buf.references()
			-- end, opts)
			vim.keymap.set("n", "<leader>gr", telescope_builtin.lsp_references, opts)
			opts.desc = "Signature Help"
			vim.keymap.set("n", "gs", function()
				vim.lsp.buf.signature_help()
			end, opts)
			opts.desc = "Rename"
			vim.keymap.set("n", "<F2>", function()
				vim.lsp.buf.rename()
			end, opts)
			opts.desc = "Format"
			vim.keymap.set({ "n", "x" }, "<F3>", function()
				vim.lsp.buf.format({ async = true })
			end, opts)
			opts.desc = "Show Code Actions"
			-- vim.keymap.set("n", "ca", function()
			-- 	vim.lsp.buf.code_action()
			-- end, opts)
			vim.keymap.set("n", "<leader>ca", "<CMD>Lspsaga code_action<CR>", opts)
			opts.desc = "Show line diagnostics"
			vim.keymap.set("n", "<leader>dl", vim.diagnostic.open_float, opts)
			opts.desc = "List Diagnostics for current buffer"
			vim.keymap.set("n", "<leader>db", function()
				telescope_builtin.diagnostics({ bufnr = 0 })
			end, opts)
			opts.desc = "List Diagnostics for all buffers"
			vim.keymap.set("n", "<leader>dw", telescope_builtin.diagnostics, opts)
			opts.desc = "Go to Next Diagnostic"
			vim.keymap.set("n", "<leader>dn", vim.diagnostic.goto_next, opts)
			opts.desc = "Go to Prev Diagnostic"
			vim.keymap.set("n", "<leader>dp", vim.diagnostic.goto_prev, opts)
		end,
	})
end

local config = function()
	create_lsp_keymaps()
	local lspconfig = require("lspconfig")

	-- Reserve a space in the gutter
	-- This will avoid an annoying layout shift in the screen
	vim.opt.signcolumn = "yes"

	-- add round borders to diagnostics float window
	vim.diagnostic.config({
		float = {
			border = "rounded",
		},
	})

	-- Add blink.cmp capabilities settings to lspconfig
	-- This should be executed before you configure any language server
	local lspconfig_defaults = lspconfig.util.default_config
	local capabilities = require("blink.cmp").get_lsp_capabilities()
	lspconfig_defaults.capabilities = vim.tbl_deep_extend("force", lspconfig_defaults.capabilities, capabilities)

	-- This is where you enable features that only work
	-- if there is a language server active in the file

	-- Change the Diagnostic symbols in the sign column (gutter)
	local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
	for type, icon in pairs(signs) do
		local hl = "DiagnosticSign" .. type
		vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
	end

	-- tailwind
	lspconfig.tailwindcss.setup({})

	-- mdx and markdown
	lspconfig.marksman.setup({
		filetypes = { "mdx", "markdown" },
	})

	-- lua
	lspconfig.lua_ls.setup({
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
		filetypes = { "json", "jsonc" },
	})

	-- python
	lspconfig.pyright.setup({
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
	-- -- typescript
	lspconfig.ts_ls.setup({
		filetypes = {
			"typescript",
			"javascript",
			"typescriptreact",
			"javascriptreact",
		},
		root_dir = lspconfig.util.root_pattern("package.json", "tsconfig.json", ".git"),
	})
	lspconfig.eslint.setup({})

	-- bash
	lspconfig.bashls.setup({
		filetypes = { "sh", "aliasrc" },
	})

	-- typescriptreact, javascriptreact, css, sass, scss, less, svelte, vue
	lspconfig.emmet_ls.setup({
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
	lspconfig.clangd.setup({})

	-- astro
	lspconfig.astro.setup({
		filetypes = { "astro" },
	})

	-- rust
	lspconfig.rust_analyzer.setup({
		filetypes = { "rust" },
		settings = {
			["rust-analyzer"] = {
				features = "all",
			},
		},
	})

	-- java
	-- lspconfig.jdtls.setup({
	-- 	filetypes = { "java" },
	-- 	handlers = {
	-- 		["language/status"] = function(_, result)
	-- 			-- Print or whatever.
	-- 		end,
	-- 		["$/progress"] = function(_, result, ctx)
	-- 			-- disable progress updates.
	-- 		end,
	-- 	},
	-- })

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
	local prettier = require("efmls-configs.formatters.prettier")
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
				markdown = { alex, prettier_d },
				mdx = { alex, prettier_d },
				html = { prettier_d },
				css = { prettier_d },
				astro = { prettier },
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
		"williamboman/mason.nvim",
		"creativenull/efmls-configs-nvim",
		{
			"folke/lazydev.nvim",
			ft = "lua", -- only load on lua files
			opts = {
				library = {
					-- See the configuration section for more details
					-- Load luvit types when the `vim.uv` word is found
					{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
				},
			},
		},
	},
	config = config,
}
