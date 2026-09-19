vim.g.mapleader = " "
vim.g.maplocalleader = " "

local map = vim.keymap.set

map({ "n", "x" }, "<Space>", "<Nop>", { desc = "Disable standalone Space", silent = true })

map("n", "<leader>U", "gUiw", { desc = "Uppercase word" })
map("n", "<leader>u", "guiw", { desc = "Lowercase word" })

map({ "n", "x" }, "<C-u>", "25<C-u>", { desc = "Scroll up 25 lines" })
map({ "n", "x" }, "<C-d>", "25<C-d>", { desc = "Scroll down 25 lines" })
map("n", "U", "<C-r>", { desc = "Redo" })
map("n", "x", '"_x', { desc = "Delete character without yanking" })
map("x", "/", "<Esc>/\\%V", { desc = "Search within visual selection" })
