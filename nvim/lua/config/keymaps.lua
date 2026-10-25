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

-- restart lsp server
-- vim.keymap.set("n", "<leader>lr", "<cmd>LspRestart<CR>", { desc = "Restart lsp server" })

-- scroll up and down
vim.keymap.set("n", "<S-u>", "<C-u>", { desc = "Scroll up" })
vim.keymap.set("n", "<S-d>", "<C-d>", { desc = "Scroll down" })

-- reload specified plugin
function _G.reload()
	for key in pairs(package.loaded) do
		if key:match("^refinery") then
			package.loaded[key] = nil
		end
	end
	return require("refinery")
end

vim.keymap.set("n", "<leader>rr", function()
	local plugin = _G.reload()
	print("Plugin reloaded!")
end, { noremap = true })

-- unified diff
vim.keymap.set("n", "<leader>df", require("unified").toggle, { desc = "Toggle unified diff" })

vim.keymap.set("n", "<leader>dt", function()
	local state = require("unified.state")
	if not state.is_active() then
		vim.notify("Unified is not active", vim.log.levels.WARN)
		return
	end
	local tree_state = require("unified.file_tree.state")
	if tree_state.window and vim.api.nvim_win_is_valid(tree_state.window) then
		require("unified.file_tree.actions").close_tree()
	else
		require("unified.file_tree").show(state.get_commit_base())
	end
end, { desc = "Toggle unified file tree" })
