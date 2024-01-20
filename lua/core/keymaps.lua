vim.g.mapleader = " "
vim.g.maplocalleader = " "

local mapkey = require("utils/keymapper").mapvimkey
local api = vim.api
local set_keymap = vim.keymap.set
local opts = require("utils/keymapper").default_opts

-- Buffer Navigation
mapkey("n","<S-l>", "bnext") -- Next buffer
mapkey("n","<S-h>", "bprevious") -- Prev buffer
mapkey("n","<leader>`", "e #") -- Switch to Other Buffer

-- Pane and Window Navigation
-- vim-tmux-navigator handles the keymaps by default with <C-h>, <C-j>, <C-k>, <C-l>

-- Window Management
mapkey("n","<leader>\\", "vsplit") -- Split Vertically
mapkey("n","<leader>-", "split") -- Split Horizontally
mapkey("n","<S-C-Up>", "resize +2")
mapkey("n","<S-C-Down>", "resize -2")
mapkey("n","<S-C-Left>", "vertical resize +2")
mapkey("n","<S-C-Right>", "vertical resize -2")

-- Comments
api.nvim_set_keymap("n", "<C-/>", "gtc", { noremap = false })
api.nvim_set_keymap("v", "<C-/>", "goc", { noremap = false })
