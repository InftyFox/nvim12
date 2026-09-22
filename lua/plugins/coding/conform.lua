local conform = require("conform")

conform.setup({
    formatters_by_ft = {
        lua = { "stylua" },
    },
    default_format_opts = {
        lsp_format = "fallback",
    },
    format_on_save = {
        timeout_ms = 2000,
    },
})

vim.keymap.set("n", "<leader>cf", function()
    conform.format({ async = true })
end, { desc = "Format current file" })
