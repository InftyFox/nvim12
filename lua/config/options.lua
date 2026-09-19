local opt = vim.opt

-- Interface
opt.winborder = "rounded"
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.termguicolors = true
opt.signcolumn = "yes"

-- Indentation
opt.smartindent = true
opt.expandtab = true
opt.shiftwidth = 4
opt.softtabstop = 4
opt.tabstop = 4

-- Search
opt.ignorecase = true
opt.smartcase = true

-- Editing
opt.clipboard:append("unnamedplus")
opt.splitright = true
opt.splitbelow = true
