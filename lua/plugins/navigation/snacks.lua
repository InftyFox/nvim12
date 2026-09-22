-- Snacks covers lightweight navigation inside Neovim: pickers search for
-- files, text, and LSP symbols, while the explorer provides a persistent tree.
-- Project file and text searches rely on `fd` and `rg` from the system PATH.
local Snacks = require("snacks")

Snacks.setup({
    explorer = {
        enabled = true,
        -- Opening a directory uses Snacks instead of Neovim's built-in netrw.
        replace_netrw = true,
    },
    picker = {
        enabled = true,
        formatters = {
            file = { filename_first = true },
        },
        sources = {
            -- Dotfiles remain visible in the project explorer.
            explorer = { hidden = true },
        },
    },
})

local map = vim.keymap.set

-- File and text discovery ----------------------------------------------------
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

-- LSP discovery -------------------------------------------------------------
-- These pickers need an attached language server that supports the requested
-- symbol or reference operation.
map("n", "<leader>ss", function()
    Snacks.picker.lsp_symbols()
end, { desc = "Find document symbols" })
map("n", "<leader>sS", function()
    Snacks.picker.lsp_workspace_symbols()
end, { desc = "Find workspace symbols" })
map("n", "<leader>sr", function()
    Snacks.picker.lsp_references()
end, { desc = "Find references" })

-- Project tree --------------------------------------------------------------
map("n", "<leader>ew", function()
    Snacks.explorer()
end, { desc = "Open project explorer" })
map("n", "<leader>ef", function()
    Snacks.explorer.reveal()
end, { desc = "Reveal current file" })
