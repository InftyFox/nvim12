local Snacks = require("snacks")

Snacks.setup({
    explorer = {
        enabled = true,
        replace_netrw = true,
    },
    picker = {
        enabled = true,
        formatters = {
            file = { filename_first = true },
        },
        sources = {
            explorer = { hidden = true },
        },
    },
})

local map = vim.keymap.set

map("n", "<leader>ff", function()
    Snacks.picker.files()
end, { desc = "Find files" })
map("n", "<leader>fs", function()
    Snacks.picker.grep()
end, { desc = "Search project text" })
map({ "n", "x" }, "<leader>fc", function()
    Snacks.picker.grep_word()
end, { desc = "Search word or selection" })
map("n", "<leader>fr", function()
    Snacks.picker.recent()
end, { desc = "Find recent files" })

map("n", "<leader>ss", function()
    Snacks.picker.lsp_symbols()
end, { desc = "Find document symbols" })
map("n", "<leader>sS", function()
    Snacks.picker.lsp_workspace_symbols()
end, { desc = "Find workspace symbols" })
map("n", "<leader>sr", function()
    Snacks.picker.lsp_references()
end, { desc = "Find references" })

map("n", "<leader>ew", function()
    Snacks.explorer()
end, { desc = "Open project explorer" })
map("n", "<leader>ef", function()
    Snacks.explorer.reveal()
end, { desc = "Reveal current file" })
