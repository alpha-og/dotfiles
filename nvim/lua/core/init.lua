-- bootstrapping lazy plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end

vim.opt.rtp:prepend(lazypath)

-- linking configuration files from "core"
require("core.options")
require("core.keymaps")
require("core.autocmds")

local plugins = {
	{ import = "plugins" },
	{ import = "plugins.lsp" },
} -- table with plugin directory path wrt "lua" directory

-- lazy setup options
local opts = {
	defaults = {
		lazy = true,
	},
	install = {
		colorscheme = {
			"catppuccin",
		},
	},
	rtp = {
		disabled_plugins = {
			"gzip",
			"matchit",
			"matchparen",
			"netrw",
			"netrwPlugin",
			"tarPlugin",
			"tohtml",
			"tutor",
			"zipPlugin",
		},
	},
	change_detection = {
		notify = true,
	},
}

local lazy = require("lazy")
lazy.setup(plugins, opts)
