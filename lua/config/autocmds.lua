-- Autocommands react to editor events. A named group makes them easy to inspect
-- and `clear = true` prevents duplicates when this module is sourced again.
-- See `:help lua-guide-autocommands`.
local group = vim.api.nvim_create_augroup("CoreAutocommands", { clear = true })

-- Briefly highlight copied text as visual confirmation that the yank succeeded.
vim.api.nvim_create_autocmd("TextYankPost", {
    group = group,
    desc = "Highlight yanked text",
    callback = function()
        vim.hl.on_yank()
    end,
})

-- Neovim stores the last cursor position in the `"` mark. Restore it after a
-- real file is read, but leave help, terminal, quickfix, and other special
-- buffers alone. See `:help '"` and `:help BufReadPost`.
vim.api.nvim_create_autocmd("BufReadPost", {
    group = group,
    desc = "Restore the last cursor position in normal file buffers",
    callback = function(args)
        -- The event may finish after another buffer became current. In that
        -- case, moving window 0 would affect the wrong window.
        if vim.bo[args.buf].buftype ~= "" or vim.api.nvim_get_current_buf() ~= args.buf then
            return
        end

        local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
        local line_count = vim.api.nvim_buf_line_count(args.buf)

        if mark[1] > 0 and mark[1] <= line_count then
            -- Window state can change between the checks and this call; failing
            -- quietly is preferable to interrupting buffer startup.
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
        end
    end,
})
