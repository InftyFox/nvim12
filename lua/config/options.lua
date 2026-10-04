-- Editor-wide defaults. `vim.opt` mirrors Vim's option system while providing
-- convenient Lua operations for list-like options such as `clipboard`.
-- See `:help lua-options` and `:help option-list`.
local opt = vim.opt

-- Interface -----------------------------------------------------------------
-- Rounded borders become the default for floating windows that honor
-- `'winborder'`. Relative numbers make count-based motions easier, while the
-- current line still displays its absolute number.
opt.winborder = "rounded"
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.termguicolors = true
-- Reserve the sign column so diagnostics do not shift the text when appearing.
opt.signcolumn = "yes"
-- ask for quit and save when quitting without saving changes
opt.confirm = true

-- Indentation ---------------------------------------------------------------
-- Insert spaces for tabs and use a consistent width for typed tabs, automatic
-- indentation, and shift commands such as `>>` and `<<`.
opt.smartindent = true
opt.expandtab = true
opt.shiftwidth = 4
opt.softtabstop = 4
opt.tabstop = 4

-- Search --------------------------------------------------------------------
-- Searches ignore case until the pattern contains an uppercase character.
-- See `:help 'ignorecase'` and `:help 'smartcase'`.
opt.ignorecase = true
opt.smartcase = true

-- Editing -------------------------------------------------------------------
-- Add the system clipboard without replacing other clipboard flags.
opt.clipboard:append("unnamedplus")
-- Show completion even for one result, but do not insert a candidate before it
-- is accepted. `popup` lets Neovim display extra completion information.
opt.completeopt = { "menu", "menuone", "noinsert", "popup" }
-- New splits open in the directions that preserve the usual reading order.
opt.splitright = true
opt.splitbelow = true
