-- Conform coordinates formatters without installing them. External executables
-- such as `stylua` must be available on the system PATH.
local conform = require("conform")

conform.setup({
    -- Prefer explicit, filetype-specific tools for reproducible formatting.
    formatters_by_ft = {
        lua = { "stylua" },
    },
    default_format_opts = {
        -- Ask an attached language server only when no configured external
        -- formatter is available for the current filetype.
        lsp_format = "fallback",
    },
    -- Save-time formatting is synchronous so the formatted contents are what
    -- reach disk. The timeout prevents a stalled formatter from blocking save.
    format_on_save = {
        timeout_ms = 2000,
    },
})

-- Manual formatting is asynchronous to keep the editor responsive. Save-time
-- formatting still applies later if the resulting buffer is written.
vim.keymap.set("n", "<leader>cf", function()
    conform.format({ async = true })
end, { desc = "Format current file" })
