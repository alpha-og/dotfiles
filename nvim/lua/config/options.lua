local opt = vim.opt -- reference variable to the global vim.opt object

-- Tab / Indentation
opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 8
opt.expandtab = true
opt.smartindent = true

-- Line wrapping
opt.wrap = true

-- Line numbers
opt.number = true -- toggle line numbers
opt.relativenumber = true -- toggle relative line numbers

-- Search settings
opt.ignorecase = true -- toggle ignore search query casing
opt.smartcase = true
opt.hlsearch = false -- toggle search result highlighting
opt.incsearch = true

-- Cursor
opt.cursorline = true -- toggle cursor line indicator

-- Appearance
opt.termguicolors = true -- allows colorschemes to work
opt.background = "dark" -- set default colorscheme mode
-- opt.colorcolumn = "100"
opt.signcolumn = "yes"
opt.cmdheight = 1
opt.scrolloff = 10
opt.completeopt = "menuone,noinsert,noselect"

-- Behaviour
opt.hidden = true
opt.errorbells = false
opt.swapfile = false
opt.backup = false
opt.undodir = vim.fn.expand("~/.vim/undodir")
opt.undofile = true
opt.backspace = "indent,eol,start"
opt.splitright = true -- window splits to the right when doing vertical split
opt.splitbelow = true -- window splits to the bottom when doing horizontal split
opt.autochdir = false
opt.iskeyword:append("-")
opt.selection = "exclusive"
opt.mouse = "a"
opt.clipboard:append("unnamedplus")
opt.modifiable = true
opt.encoding = "UTF-8"
opt.showmode = false

-- folds
opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"
opt.foldlevel = 99

-- make command line go away
opt.cmdheight = 0
