-- Native LSP client configuration shared by every language server. Servers and
-- external tools are installed outside Neovim; this module controls how Neovim
-- presents their results and enables `lua_ls`. See `:help lsp`.

-- Keep diagnostics visible through signs and underlines, but avoid adding text
-- beside or below every affected line. Details remain available on demand.
vim.diagnostic.config({
    signs = true,
    underline = true,
    virtual_text = false,
    virtual_lines = false,
    severity_sort = true,
    update_in_insert = false,
})

local group = vim.api.nvim_create_augroup("LspConfiguration", { clear = true })

-- `LspAttach` runs once a client is connected to a buffer. Completion is
-- enabled buffer-locally and only when that client advertises support for it,
-- preventing completion mappings in unrelated files.
vim.api.nvim_create_autocmd("LspAttach", {
    group = group,
    desc = "Enable native LSP completion",
    callback = function(args)
        local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

        if client:supports_method("textDocument/completion") then
            -- `autotrigger` requests candidates while typing; `<C-Space>` is an
            -- explicit refresh when automatic triggering is not sufficient.
            vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
            vim.keymap.set("i", "<C-Space>", vim.lsp.completion.get, {
                buffer = args.buf,
                desc = "Trigger LSP completion",
            })
        end
    end,
})

-- Keep diagnostic details explicit instead of opening floats automatically.
-- `source = "if_many"` identifies providers only when several are involved.
vim.keymap.set("n", "<leader>cd", function()
    vim.diagnostic.open_float(nil, {
        scope = "line",
        focusable = false,
        source = "if_many",
    })
end, { desc = "Show line diagnostics" })

-- These expression mappings return the keys Neovim should execute. This keeps
-- one Tab workflow for the completion popup, native snippets, and literal tabs.
-- See `:help map-expression` and `:help vim.snippet`.
vim.keymap.set({ "i", "s" }, "<Tab>", function()
    if vim.fn.pumvisible() == 1 then
        -- `<C-y>` confirms the currently selected completion item.
        return "<C-y>"
    end

    if vim.snippet.active({ direction = 1 }) then
        -- Once a snippet is active, Tab advances to its next placeholder.
        return "<Cmd>lua vim.snippet.jump(1)<CR>"
    end

    return "<Tab>"
end, { expr = true, silent = true, desc = "Accept completion or jump in snippet" })

-- Enter deliberately never accepts a completion. When the popup is visible,
-- `<C-e>` dismisses it before the normal newline is inserted.
vim.keymap.set("i", "<CR>", function()
    if vim.fn.pumvisible() == 1 then
        return "<C-e><CR>"
    end

    return "<CR>"
end, { expr = true, silent = true, desc = "Cancel completion and insert newline" })

-- nvim-lspconfig provides the base profile; Neovim automatically merges the
-- local extension from `after/lsp/lua_ls.lua` before starting the server.
-- See `:help vim.lsp.enable()` and `:help lsp-config`.
vim.lsp.enable("lua_ls")
