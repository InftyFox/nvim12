local group = vim.api.nvim_create_augroup("CoreAutocommands", { clear = true })

vim.api.nvim_create_autocmd("TextYankPost", {
    group = group,
    desc = "Highlight yanked text",
    callback = function()
        vim.hl.on_yank()
    end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
    group = group,
    desc = "Restore the last cursor position in normal file buffers",
    callback = function(args)
        if vim.bo[args.buf].buftype ~= "" or vim.api.nvim_get_current_buf() ~= args.buf then
            return
        end

        local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
        local line_count = vim.api.nvim_buf_line_count(args.buf)

        if mark[1] > 0 and mark[1] <= line_count then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
        end
    end,
})
