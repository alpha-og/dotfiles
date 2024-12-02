-- auto-format on save
local lsp_fmt_group = vim.api.nvim_create_augroup("LspFormattingGroup", {})
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*.go",
	callback = function()
		local params = vim.lsp.util.make_range_params()
		params.context = { only = { "source.organizeImports" } }
		-- buf_request_sync defaults to a 1000ms timeout. Depending on your
		-- machine and codebase, you may want longer. Add an additional
		-- argument after params if you find that you have to write the file
		-- twice for changes to be saved.
		-- E.g., vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
		local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params)
		for cid, res in pairs(result or {}) do
			for _, r in pairs(res.result or {}) do
				if r.edit then
					local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
					vim.lsp.util.apply_workspace_edit(r.edit, enc)
				end
			end
		end
		vim.lsp.buf.format({ async = false })
	end,
})
vim.api.nvim_create_autocmd("BufWritePre", {
	group = lsp_fmt_group,
	callback = function()
		if vim.lsp.get_clients then
			local efm = vim.lsp.get_clients({ name = "efm" })
			-- local ast_grep = vim.lsp.get_clients({ name = "ast_grep" })
			-- local biome = vim.lsp.get_clients({ name = "biome" })
			if not vim.tbl_isempty(efm) then
				if vim.bo.filetype == "c" or vim.bo.filetype == "cpp" then
					return vim.lsp.buf.format({ name = "efm", async = true })
				else
					return vim.lsp.buf.format({ name = "efm", async = false })
				end
				-- elseif not vim.tbl_isempty(ast_grep) then
				-- 	return vim.lsp.buf.format({ name = "ast_grep", async = false })
				-- elseif not vim.tbl_isempty(biome) then
				-- 	vim.lsp.buf.format({ name = "biome", async = false })
			end
		else
			return
		end
	end,
})

-- highlight on yank
local highlight_yank_group = vim.api.nvim_create_augroup("HighlightYankGroup", {})
vim.api.nvim_create_autocmd("TextYankPost", {
	group = highlight_yank_group,
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- mason-tool install notifier
vim.api.nvim_create_autocmd("User", {
	pattern = "MasonToolsStartingInstall",
	callback = function()
		vim.schedule(function()
			print("mason-tool-installer is starting")
		end)
	end,
})

-- mason-tool install completion notifier
vim.api.nvim_create_autocmd("User", {
	pattern = "MasonToolsUpdateCompleted",
	callback = function(e)
		vim.schedule(function()
			print(vim.inspect(e.data)) -- print the table that lists the programs that were installed
		end)
	end,
})
