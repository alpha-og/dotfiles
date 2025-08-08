-- auto-format: https://vonheikemen.github.io/devlog/tools/neovim-lsp-client-guide/
local fmt_group = vim.api.nvim_create_augroup("autoformat_cmds", { clear = true })

local function setup_autoformat(event)
	local id = vim.tbl_get(event, "data", "client_id")
	local client = id and vim.lsp.get_client_by_id(id)
	if client == nil then
		return
	end
	vim.api.nvim_clear_autocmds({ group = fmt_group, buffer = event.buf })

	local buf_format = function(e)
		vim.lsp.buf.format({
			bufnr = e.buf,
			async = false,
			timeout_ms = 10000,
		})
	end

	vim.api.nvim_create_autocmd("BufWritePre", {
		buffer = event.buf,
		group = fmt_group,
		desc = "Format current buffer",
		callback = buf_format,
	})
end

vim.api.nvim_create_autocmd("LspAttach", {
	desc = "Setup format on save",
	callback = setup_autoformat,
})

-- highlight on yank
local highlight_yank_group = vim.api.nvim_create_augroup("HighlightYankGroup", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
	group = highlight_yank_group,
	callback = function()
		vim.hl.on_yank({
			timeout = 100,
		})
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

-- terminal
vim.api.nvim_create_autocmd("TermOpen", {
	group = vim.api.nvim_create_augroup("CustomTermOpen", { clear = true }),
	callback = function()
		vim.opt.number = false
		vim.opt.relativenumber = false
	end,
})
