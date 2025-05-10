-- plugin for installing and managing lsp servers and other tools

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
		},
		auto_update = true,
	})
end

return {
	"williamboman/mason.nvim",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},
	cmd = "Mason",
	event = "BufReadPre",
	config = config,
}
