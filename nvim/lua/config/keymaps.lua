-- set leader key
vim.g.mapleader = " "

-- open explorer
vim.keymap.set("n", "<leader>ee", vim.cmd.Ex, { desc = "Open explorer" })

-- Move lines up and down
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move line down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move line up" })

-- cursor remains at center of screen while scrolling
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll down with center cursor" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll up with center cursor" })

-- paste over selected text without losing copied text
vim.keymap.set("x", "<leader>p", '"_dP', { desc = "Paste without deleting copied text" })

-- delete without copying deleted text
vim.keymap.set("n", "<leader>d", '"_d', { desc = "Delete without copying deleted text" })
-- delete block without copying deleted text
vim.keymap.set("n", "<leader>d", '"_d', { desc = "Delete block without copying deleted text" })

vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz", { desc = "Next match" })
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz", { desc = "Previous match" })
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz", { desc = "Next match" })
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz", { desc = "Previous match" })

-- open terminal in a vertical split
vim.keymap.set("n", "<leader>tv", function()
	vim.cmd.vnew()
	vim.cmd.terminal()
	vim.cmd.wincmd("L")
	local width = vim.api.nvim_win_get_width(0)
	local terminal_width = math.floor(width * 0.5)
	vim.api.nvim_win_set_width(0, terminal_width)
	vim.cmd.startinsert()
end, { desc = "Open terminal in a vertical split" })

-- open terminal in a horizontal split
vim.keymap.set("n", "<leader>th", function()
	vim.cmd.new()
	vim.cmd.terminal()
	vim.cmd.wincmd("J")
	local height = vim.api.nvim_win_get_height(0)
	local terminal_height = math.floor(height * 0.4)
	vim.api.nvim_win_set_height(0, terminal_height)
	vim.cmd.startinsert()
end, { desc = "Open terminal in a horizontal split" })

-- open terminal in a floating window
vim.keymap.set("n", "<leader>tf", function()
	vim.api.nvim_open_win(0, true, {
		relative = "win",
		width = math.floor(vim.o.columns * 0.8),
		height = math.floor(vim.o.lines * 0.8),
		row = math.floor((vim.o.lines - vim.o.lines * 0.8) / 2),
		col = math.floor((vim.o.columns - vim.o.columns * 0.8) / 2),
		style = "minimal",
		border = "rounded",
	})
	vim.cmd.terminal()
	vim.cmd.startinsert()
end, { desc = "Open terminal in a floating window" })
