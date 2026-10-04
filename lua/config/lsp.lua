-- Native LSP client configuration shared by every language server. Servers and
-- external tools are installed outside Neovim; this module controls how Neovim
-- presents their results and enables language profiles. See `:help lsp`.

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

-- Keep diagnostic details explicit instead of opening floats automatically.
-- `source = "if_many"` identifies providers only when several are involved.
vim.keymap.set("n", "<leader>cd", function()
    vim.diagnostic.open_float(nil, {
        scope = "line",
        focusable = false,
        source = "if_many",
    })
end, { desc = "Show line diagnostics" })

vim.keymap.set({ "n", "x" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "LSP code actions" })

-- nvim-lspconfig provides the base profiles; Neovim automatically merges the
-- local extension from `after/lsp/lua_ls.lua` before starting that server.
-- See `:help vim.lsp.enable()` and `:help lsp-config`.
vim.lsp.enable("lua_ls")
vim.lsp.enable("jsonls")
vim.lsp.enable("yamlls")
vim.lsp.enable("csharp_ls")
