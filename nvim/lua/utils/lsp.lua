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
	vim.keymap.set(
		"n",
		"<leader>fr",
		"<CMD>Lspsaga finder<CR>",
		{ noremap = true, silent = true, desc = "Open lspsaga finder", buffer = bufnr }
	) -- open lsp saga finder
	vim.keymap.set(
		"n",
		"gd",
		"<CMD>Lspsaga peek_definition<CR>",
		{ noremap = true, silent = true, desc = "Peak definition", buffer = bufnr }
	) -- peak definition
	vim.keymap.set(
		"n",
		"gD",
		"<CMD>Lspsaga goto_definition<CR>",
		{ noremap = true, silent = true, desc = "Go to definition", buffer = bufnr }
	) -- go to definition
	vim.keymap.set(
		"n",
		"<leader>ca",
		"<CMD>Lspsaga code_action<CR>",
		{ noremap = true, silent = true, desc = "See available code actions", buffer = bufnr }
	) -- see available code actions
	vim.keymap.set(
		"n",
		"<leader>rn",
		"<CMD>Lspsaga rename<CR>",
		{ noremap = true, silent = true, desc = "Smart rename", buffer = bufnr }
	) -- smart rename
	vim.keymap.set(
		"n",
		"<leader>dl",
		"<CMD>Lspsaga show_line_diagnostics<CR>",
		{ noremap = true, silent = true, desc = "Show line diagnostics", buffer = bufnr }
	) -- show  diagnostics for line
	vim.keymap.set(
		"n",
		"<leader>dc",
		"<CMD>Lspsaga show_cursor_diagnostics<CR>",
		{ noremap = true, silent = true, desc = "Show cursor diagnostics", buffer = bufnr }
	) -- show diagnostics for cursor

	vim.keymap.set(
		"n",
		"<leader>ds",
		"<CMD>Lspsaga diagnostic_jump_prev<CR>",
		{ noremap = true, silent = true, desc = "Jump to previous diagnostic in buffer", buffer = bufnr }
	) -- jump to prev diagnostic in buffer

	vim.keymap.set(
		"n",
		"<leader>dp",
		"<CMD>Lspsaga diagnostic_jump_next<CR>",
		{ noremap = true, silent = true, desc = "Jump to next diagnostic in buffer", buffer = bufnr }
	) -- jump to next diagnostic in buffer

	vim.keymap.set(
		"n",
		"K",
		"<CMD>Lspsaga hover_doc<CR>",
		{ noremap = true, silent = true, desc = "Show hover documentation" }
	) -- show documentation for what is under cursor

	if client.name == "pyright" then
		vim.keymap.set(
			"n",
			"<leader>oi",
			"<CMD>PyrightOrganizeImports<CR>",
			{ noremap = true, silent = true, desc = "Organise python imports", buffer = bufnr }
		) -- organise imports
		vim.keymap.set(
			"n",
			"<leader>db",
			"<CMD>DapToggleBreakpoint<CR>",
			{ noremap = true, silent = true, desc = "Add breakpoint", buffer = bufnr }
		) -- toggle breakpoint
		vim.keymap.set(
			"n",
			"<leader>dr",
			"<CMD>DapContinue<CR>",
			{ noremap = true, silent = true, desc = "Invoke debugger", buffer = bufnr }
		) -- continue/invoke debugger
		vim.keymap.set(
			"n",
			"<leader>dt",
			"<CMD>lua require('dap-python').test_method()<CR>",
			{ noremap = true, silent = true, desc = "Run tests", buffer = bufnr }
		) -- run tests
	end
end

return M
