-- local keymap = vim.keymap -- for conciseness
local mapkey = require("utils/keymapper").mapvimkey

local M = {}

M.on_attach = function(client, bufnr)
	-- local opts = { noremap = true, silent = true, buffer = bufnr }

	-- native vim lsp + telescope keybinds
	-- opts.desc = "Show LSP references"
	-- keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references
	--
	-- opts.desc = "Go to declaration"
	-- keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- go to declaration
	--
	-- opts.desc = "Show LSP definitions"
	-- keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts) -- show lsp definitions
	--
	-- opts.desc = "Show LSP implementations"
	-- keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts) -- show lsp implementations
	--
	-- opts.desc = "Show LSP type definitions"
	-- keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- show lsp type definitions
	--
	-- opts.desc = "See available code actions"
	-- keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection
	--
	-- opts.desc = "Smart rename"
	-- keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts) -- smart rename
	--
	-- opts.desc = "Show buffer diagnostics"
	-- keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show  diagnostics for file
	--
	-- opts.desc = "Show line diagnostics"
	-- keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts) -- show diagnostics for line
	--
	-- opts.desc = "Go to previous diagnostic"
	-- keymap.set("n", "ds", vim.diagnostic.goto_prev, opts) -- jump to previous diagnostic in buffer
	--
	-- opts.desc = "Go to next diagnostic"
	-- keymap.set("n", "df", vim.diagnostic.goto_next, opts) -- jump to next diagnostic in buffer

	-- opts.desc = "Show documentation for what is under cursor"
	-- keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

	-- opts.desc = "Restart LSP"
	-- keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary

	-- lspsaga keymaps
	mapkey("n", "<leader>fd", "Lspsaga finder", { desc = "Open lspsaga finder", buffer = bufnr }) -- open lsp saga finder
	mapkey("n", "gd", "Lspsaga peek_definition", { desc = "Peak definition", buffer = bufnr }) -- peak definition
	mapkey("n", "gD", "Lspsaga goto_definition", { desc = "Go to definition", buffer = bufnr }) -- go to definition
	mapkey("n", "<leader>ca", "Lspsaga code_action", { desc = "See available code actions", buffer = bufnr }) -- see available code actions
	mapkey("n", "<leader>rn", "Lspsaga rename", { desc = "Smart rename", buffer = bufnr }) -- smart rename
	mapkey("n", "<leader>dl", "Lspsaga show_line_diagnostics", { desc = "Show line diagnostics", buffer = bufnr }) -- show  diagnostics for line
	mapkey("n", "<leader>dc", "Lspsaga show_cursor_diagnostics", { desc = "Show cursor diagnostics", buffer = bufnr }) -- show diagnostics for cursor
	mapkey(
		"n",
		"<leader>ds",
		"Lspsaga diagnostic_jump_prev",
		{ desc = "Jump to previous diagnostic in buffer", buffer = bufnr }
	) -- jump to prev diagnostic in buffer
	mapkey(
		"n",
		"<leader>dp",
		"Lspsaga diagnostic_jump_next",
		{ desc = "Jump to next diagnostic in buffer", buffer = bufnr }
	) -- jump to next diagnostic in buffer
	mapkey("n", "K", "Lspsaga hover_doc", { desc = "Show hover documentation" }) -- show documentation for what is under cursor

	if client.name == "pyright" then
		mapkey("n", "<leader>oi", "PyrightOrganizeImports", { desc = "Organise python imports", buffer = bufnr }) -- organise imports
		mapkey("n", "<leader>db", "DapToggleBreakpoint", { desc = "Add breakpoint", buffer = bufnr }) -- toggle breakpoint
		mapkey("n", "<leader>dr", "DapContinue", { desc = "Invoke debugger", buffer = bufnr }) -- continue/invoke debugger
		mapkey("n", "<leader>dt", "lua require('dap-python').test_method()", { desc = "Run tests", buffer = bufnr }) -- run tests
	end
end

return M
