-- plugin configuration for handling neovim's native lsp

local create_lsp_keymaps = function()
	vim.api.nvim_create_autocmd("LspAttach", {
		callback = function(event)
			local opts = { buffer = event.buf, noremap = true, silent = true }
			opts.desc = "Hover"
			vim.keymap.set("n", "K", function()
				vim.lsp.buf.hover()
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
			vim.keymap.set("n", "<leader>ca", "<CMD>Lspsaga code_action<CR>", opts)
			opts.desc = "Show line diagnostics"
			vim.keymap.set("n", "<leader>dl", vim.diagnostic.open_float, opts)
			opts.desc = "List Diagnostics for current buffer"
			opts.desc = "Go to Next Diagnostic"
			vim.keymap.set("n", "<leader>dn", vim.diagnostic.get_next, opts)
			opts.desc = "Go to Prev Diagnostic"
			vim.keymap.set("n", "<leader>dp", vim.diagnostic.get_prev, opts)
		end,
	})
end

local config = function()
	local mason = require("mason")
	local mason_lspconfig = require("mason-lspconfig")
	local mason_tool_installer = require("mason-tool-installer")
	mason.setup({
		ui = {
			icons = {
				package_installed = "✓",
				package_pending = "➜",
				package_uninstalled = "✗",
			},
		},
	})

	mason_lspconfig.setup({
		-- list of lsp for mason to install
		ensure_installed = {
			"efm",
			"ts_ls",
			"eslint",
			"html",
			"cssls",
			"tailwindcss",
			"svelte",
			"lua_ls",
			-- "graphql",
			"emmet_ls",
			-- "prismals",
			"pyright",
			"astro",
			"clangd",
			"bashls",
			"jsonls",
			"rust_analyzer",
			"biome",
			"taplo",
			"vue_ls",
		},
		-- auto-install configured servers (with lspconfig)
		automatic_installation = true, -- not the same as ensure_installed
	})

	mason_tool_installer.setup({
		ensure_installed = {
			"luacheck", -- lua linter
			"stylua", -- lua formatter
			"flake8", -- python linter
			"black", -- python formatter
			"prettierd", -- prettier daemon formatter
			"prettier", -- prettier formatter
			"eslint_d", -- ts/js linter
			"fixjson", -- json formatter
			"shellcheck", -- shell linter
			"shfmt", -- shell formatter
			"cpplint", -- cpp linter
			"clang-format", -- c/cpp formatter
			"alex", -- markdown linter
			"codelldb", -- lldb debugger
			"taplo", -- toml formatter
			"vue_ls",
		},
		auto_update = true,
	})

	create_lsp_keymaps()
	local lspconfig = vim.lsp.config

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
	-- local lspconfig_defaults = lspconfig.util.default_config
	-- local capabilities = require("blink.cmp").get_lsp_capabilities()
	-- lspconfig_defaults.capabilities = vim.tbl_deep_extend("force", lspconfig_defaults.capabilities, capabilities)

	-- This is where you enable features that only work
	-- if there is a language server active in the file

	-- Change the Diagnostic symbols in the sign column (gutter)
	local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
	for type, icon in pairs(signs) do
		local hl = "DiagnosticSign" .. type
		vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
	end

	-- tailwind
	lspconfig.tailwindcss = {
		filetypes = {
			"html",
			"css",
			"scss",
			"javascript",
			"javascriptreact",
			"typescript",
			"typescriptreact",
			"svelte",
			"astro",
			"vue",
		},
	}

	-- mdx and markdown
	lspconfig.marksman = {
		filetypes = { "mdx", "markdown" },
	}

	-- lua
	lspconfig.lua_ls = {
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
	}

	-- json
	lspconfig.jsonls = {
		filetypes = { "json", "jsonc" },
	}

	-- python
	lspconfig.pyright = {
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
	}

	local vue_language_server_path = vim.fn.stdpath("data")
		.. "/mason/packages/vue-language-server/node_modules/@vue/language-server"
	local tsserver_filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" }
	local vue_plugin = {
		name = "@vue/typescript-plugin",
		location = vue_language_server_path,
		languages = { "vue" },
		configNamespace = "typescript",
	}

	lspconfig.vtsls = {
		settings = {
			vtsls = {
				tsserver = {
					globalPlugins = {
						vue_plugin,
					},
				},
			},
		},
		filetypes = tsserver_filetypes,
	}

	lspconfig.vue_ls = {}

	-- typescript
	lspconfig.ts_ls = {
		init_options = {
			plugins = {
				{
					name = "@vue/typescript-plugin",
					location = vue_language_server_path,
					languages = { "vue" },
				},
			},
		},
		filetypes = {
			"typescript",
			"javascript",
			"typescriptreact",
			"javascriptreact",
		},
		root_dir = function(bufnr, on_dir)
			on_dir(vim.fs.root(bufnr, { "package.json", "tsconfig.json", ".git" }))
		end,
	}

	-- vue (volar)
	-- lspconfig.volar = {
	-- 	filetypes = { "vue" },
	-- 	init_options = {
	-- 		vue = {
	-- 			hybridMode = false,
	-- 		},
	-- 	},
	-- 	settings = {
	-- 		typescript = {
	-- 			inlayHints = {
	-- 				enumMemberValues = {
	-- 					enabled = true,
	-- 				},
	-- 				functionLikeReturnTypes = {
	-- 					enabled = true,
	-- 				},
	-- 				propertyDeclarationTypes = {
	-- 					enabled = true,
	-- 				},
	-- 				parameterTypes = {
	-- 					enabled = true,
	-- 					suppressWhenArgumentMatchesName = true,
	-- 				},
	-- 				variableTypes = {
	-- 					enabled = true,
	-- 				},
	-- 			},
	-- 		},
	-- 	},
	-- root_dir = function(bufnr, on_dir)
	-- 	on_dir(vim.fs.root(bufnr, { "package.json", "tsconfig.json", ".git" }))
	-- end,
	-- }

	-- lspconfig.eslint = {}
	-- lspconfig.svelte = {}

	-- bash
	lspconfig.bashls = {
		filetypes = { "sh", "aliasrc" },
	}

	lspconfig.cssls = {}

	-- typescriptreact, javascriptreact, css, sass, scss, less, svelte, vue
	lspconfig.emmet_ls = {
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
	}

	-- C/C++
	lspconfig.clangd = {
		cmd = {
			"clangd",
			"--background-index",
			"--clang-tidy",
		},
		-- clangd ignores fallbackFlags when it finds a compile_commands.json,
		-- so this only kicks in for rootless files (leetcode, quick scratch files, etc.)
		--
		-- needed because leetcode.nvim injects `#include <bits/stdc++.h>` and
		-- `using namespace std;` virtually -- clangd never sees them, only the
		-- raw file on disk. so we force-include our own stdc++.h to match.
		--
		-- can't just use bits/stdc++.h directly, apple clang doesn't ship it (gcc thing).
		-- maintaining a manual one at the path below, add headers there as needed.
		init_options = {
			fallbackFlags = {
				"-std=c++17",
				"-xc++",
				"-include",
				vim.fn.expand("~/.config/nvim/lua/config/plugins/lsp/cpp_headers/stdc++.h"),
			},
		},
		root_dir = function(bufnr, on_dir)
			local root = vim.fs.root(bufnr, {
				".clangd",
				".clang-tidy",
				".clang-format",
				"compile_commands.json",
				"compile_flags.txt",
				".git",
			})
			-- without a root clangd won't apply fallbackFlags, so fall back to
			-- the buffer's directory instead of returning nil
			on_dir(root or vim.fs.dirname(vim.api.nvim_buf_get_name(bufnr)))
		end,
	}

	-- astro
	lspconfig.astro = {
		filetypes = { "astro" },
	}

	-- rust
	lspconfig.rust_analyzer = {
		filetypes = { "rust" },
		settings = {
			["rust-analyzer"] = {
				features = "all",
				check = {
					extraArgs = { "--target-dir", "target/check" },
				},
				diagnostics = {
					enable = true,
				},
			},
		},
	}

	-- verilog
	lspconfig.verible = {}

	-- java
	-- lspconfig.jdtls = {
	-- 	filetypes = { "java" },
	-- 	handlers = {
	-- 		["language/status"] = function(_, result)
	-- 			-- Print or whatever.
	-- 		end,
	-- 		["$/progress"] = function(_, result, ctx)
	-- 			-- disable progress updates.
	-- 		end,
	-- 	},
	-- }

	-- go
	lspconfig.gopls = {}

	-- toml
	lspconfig.taplo = {}

	local luacheck = require("efmls-configs.linters.luacheck")
	local stylua = require("efmls-configs.formatters.stylua")
	-- local flake8 = require("efmls-configs.linters.flake8")
	local black = require("efmls-configs.formatters.black")
	local eslint_d = require("efmls-configs.linters.eslint_d")
	local prettier_d = require("efmls-configs.formatters.prettier_d")
	local prettier = require("efmls-configs.formatters.prettier")
	-- local fixjson = require("efmls-configs.formatters.fixjson")
	local shellcheck = require("efmls-configs.linters.shellcheck")
	local shfmt = require("efmls-configs.formatters.shfmt")
	-- local cpplint = require("efmls-configs.linters.cpplint")
	local clangformat = require("efmls-configs.formatters.clang_format")
	-- local alex = require("efmls-configs.linters.alex")
	local taplo = require("efmls-configs.formatters.taplo")

	-- configure efm server
	lspconfig.efm = {
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
			"verilog",
			"systemverilog",
			"toml",
			"vue",
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
			rootMarkers = { ".git/" },
			languages = {
				lua = { luacheck, stylua },
				python = { black },
				json = { eslint_d, prettier_d },
				jsonc = { eslint_d, prettier_d },
				sh = { shellcheck, shfmt },
				typescript = { eslint_d, prettier_d },
				javascript = { eslint_d, prettier_d },
				javascriptreact = { eslint_d, prettier_d },
				typescriptreact = { eslint_d, prettier_d },
				svelte = { eslint_d, prettier_d },
				markdown = { prettier_d },
				mdx = { prettier_d },
				html = { prettier_d },
				css = { prettier_d },
				vue = { prettier_d },
				astro = { prettier },
				rust = { { formatCommand = "rustfmt --edition 2024 --emit=stdout", formatStdin = true } },
				java = {},
				go = { { formatCommand = "gofmt", formatStdin = true } },
				c = { clangformat },
				cpp = { clangformat },
				toml = { taplo },
			},
		},
	}
end

return {
	"mason-org/mason-lspconfig.nvim",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"mason-org/mason.nvim",
		"creativenull/efmls-configs-nvim",
		"neovim/nvim-lspconfig",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
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
