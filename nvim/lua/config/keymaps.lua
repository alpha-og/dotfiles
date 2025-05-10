-- set leader key
-- vim.g.mapleader = " "
-- vim.g.maplocalleader = ";"

-- open explorer
vim.keymap.set("n", "<leader>e", "<cmd>Oil<CR>", { desc = "Open explorer with oil.nvim" })

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

-- vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz", { desc = "Next match" })
-- vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz", { desc = "Previous match" })
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz", { desc = "Next match" })
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz", { desc = "Previous match" })
