-- auto-format on save
local lsp_fmt_group = vim.api.nvim_create_augroup("LspFormattingGroup", {})
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
