vim.g.mapleader = " "
vim.g.maplocalleader = " "

local api = vim.api

-- Buffer Navigation
vim.keymap.set("n", "<S-l>", "<CMD>bnext<CR>", {noremap=true, silent=true, desc = "Next buffer" }) -- Next buffer
vim.keymap.set("n", "<S-h>", "<CMD>bprevious<CR>", {noremap=true, silent=true, desc = "Prev buffer" }) -- Prev buffer
vim.keymap.set("n", "<leader>o", "<CMD>e #<CR>", {noremap=true, silent=true, desc = "Switch to Other Buffer" }) -- Switch to Other Buffer

-- Buffer Management
vim.keymap.set("n", "<leader>bd", "<CMD>lua MiniBufremove.delete()<CR>", {noremap=true, silent=true, desc = "Delete active buffer" })
vim.keymap.set("n", "<leader>bD", "<CMD>lua MiniBufremove.delete(0,true)<CR>", {noremap=true, silent=true, desc = "Force delete active buffer" })

-- Pane and Window Navigation
-- vim-tmux-navigator handles the keymaps by default with <C-h>, <C-j>, <C-k>, <C-l>

-- Window Management
vim.keymap.set("n", "<leader>\\", "<CMD>vsplit<CR>", {noremap=true, silent=true, desc = "Split Vertically" }) -- Split Vertically
vim.keymap.set("n", "<leader>-", "<CMD>split<CR>", {noremap=true, silent=true, desc = "Split Horizontally" }) -- Split Horizontally
vim.keymap.set("n", "<S-C-Up>", "<CMD>resize +2<CR>", {noremap=true, silent=true ,desc = "Resize window up"})
vim.keymap.set("n", "<S-C-Down>", "<CMD>resize -2<CR>", {noremap=true, silent=true, desc = "Resize window down"})
vim.keymap.set("n", "<S-C-Left>", "<CMD>vertical resize +2<CR>", {noremap=true, silent=true, desc = "Resize window left"})
vim.keymap.set("n", "<S-C-Right>", "<CMD>vertical resize -2<CR>", {noremap=true, silent=true, desc = "Resize window right"})

-- Comments
api.nvim_set_keymap("n", "<C-/>", "gtc", { noremap = false })
api.nvim_set_keymap("v", "<C-/>", "goc", { noremap = false })

-- Indenting
vim.keymap.set("v", "<", "<gv", { silent = true, noremap = true })
vim.keymap.set("v", ">", ">gv", { silent = true, noremap = true })
