-- Global, plugin-independent mappings. Set both leaders before any plugin is
-- configured so `<leader>` is expanded consistently everywhere.
-- See `:help mapleader` and `:help vim.keymap.set()`.
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local map = vim.keymap.set

-- Space acts only as the leader prefix; pressing it by itself does nothing.
map({ "n", "x" }, "<Space>", "<Nop>", { desc = "Disable standalone Space", silent = true })

-- Change the word under the cursor without first selecting it.
map("n", "<leader>U", "gUiw", { desc = "Uppercase word" })
map("n", "<leader>u", "guiw", { desc = "Lowercase word" })

-- Use predictable larger scroll steps instead of the window-dependent defaults.
map({ "n", "x" }, "<C-u>", "25<C-u>", { desc = "Scroll up 25 lines" })
map({ "n", "x" }, "<C-d>", "25<C-d>", { desc = "Scroll down 25 lines" })
-- Repurpose `U` for redo and delete single characters into the black-hole
-- register so they do not replace text waiting to be pasted.
map("n", "U", "<C-r>", { desc = "Redo" })
map("n", "x", '"_x', { desc = "Delete character without yanking" })
-- `\%V` constrains the following search pattern to the previous visual area.
-- See `:help /\%V`.
map("x", "/", "<Esc>/\\%V", { desc = "Search within visual selection" })
