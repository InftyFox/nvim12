local pairs = require("mini.pairs")
pairs.setup()

-- Enter cancels completion rather than accepting it, then splits empty pairs.
-- MiniPairs.cr() already returns encoded keys, so do not replace them again.
vim.keymap.set("i", "<CR>", function()
    local keys = pairs.cr()
    if vim.fn.pumvisible() == 1 then
        return vim.api.nvim_replace_termcodes("<C-e>", true, false, true) .. keys
    end

    return keys
end, { expr = true, replace_keycodes = false, silent = true, desc = "Cancel completion and split pairs" })
