-- Shared diagnostic presentation for every attached language server.
vim.diagnostic.config({
    signs = true,
    underline = true,
    virtual_text = false,
    virtual_lines = false,
    severity_sort = true,
    update_in_insert = false,
})

local group = vim.api.nvim_create_augroup("LspConfiguration", { clear = true })

-- Enable completion only in buffers whose attached server supports it.
vim.api.nvim_create_autocmd("LspAttach", {
    group = group,
    desc = "Enable native LSP completion",
    callback = function(args)
        local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

        if client:supports_method("textDocument/completion") then
            vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
            vim.keymap.set("i", "<C-Space>", vim.lsp.completion.get, {
                buffer = args.buf,
                desc = "Trigger LSP completion",
            })
        end
    end,
})

-- Keep diagnostic details explicit instead of opening floats automatically.
vim.keymap.set("n", "<leader>cd", function()
    vim.diagnostic.open_float(nil, {
        scope = "line",
        focusable = false,
        source = "if_many",
    })
end, { desc = "Show line diagnostics" })

-- Tab accepts a visible completion, then falls back to native snippet navigation.
vim.keymap.set({ "i", "s" }, "<Tab>", function()
    if vim.fn.pumvisible() == 1 then
        return "<C-y>"
    end

    if vim.snippet.active({ direction = 1 }) then
        return "<Cmd>lua vim.snippet.jump(1)<CR>"
    end

    return "<Tab>"
end, { expr = true, silent = true, desc = "Accept completion or jump in snippet" })

-- Enter always inserts a newline; it never accepts the selected completion.
vim.keymap.set("i", "<CR>", function()
    if vim.fn.pumvisible() == 1 then
        return "<C-e><CR>"
    end

    return "<CR>"
end, { expr = true, silent = true, desc = "Cancel completion and insert newline" })

-- nvim-lspconfig provides the base profile; after/lsp/lua_ls.lua extends it.
vim.lsp.enable("lua_ls")
