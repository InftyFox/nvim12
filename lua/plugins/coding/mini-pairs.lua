local pairs = require("mini.pairs")
pairs.setup()

-- Blink confirms completion on Enter and cancels it on Shift-Enter, falling
-- back to these mappings for pair-aware newlines. Also dismiss native popups.
-- MiniPairs.cr() already returns encoded keys, so do not replace them again.
local function newline()
    local keys = pairs.cr()
    if vim.fn.pumvisible() == 1 then
        return vim.api.nvim_replace_termcodes("<C-e>", true, false, true) .. keys
    end

    return keys
end

vim.keymap.set("i", "<CR>", newline, {
    expr = true,
    replace_keycodes = false,
    silent = true,
    desc = "Insert newline and split pairs",
})
vim.keymap.set({ "i", "s" }, "<S-CR>", newline, {
    expr = true,
    replace_keycodes = false,
    silent = true,
    desc = "Insert newline and split pairs without accepting completion",
})
