-- Blink owns insert-mode completion; LSP clients still use Neovim's native API.
-- Its plugin registers LSP capabilities before the language profiles are enabled.
require("blink.cmp").setup({
    keymap = {
        preset = "enter",
        ["<S-CR>"] = {
            function(cmp)
                -- Always continue to mini.pairs' newline mapping, even when a
                -- visible completion was cancelled successfully.
                cmp.cancel()
            end,
            "fallback",
        },
        ["<C-d>"] = { "scroll_documentation_down", "fallback" },
        ["<C-u>"] = { "scroll_documentation_up", "fallback" },
        ["<C-b>"] = false,
        ["<C-f>"] = false,
    },
    appearance = {
        nerd_font_variant = "normal",
    },
    completion = {
        list = {
            selection = { preselect = true, auto_insert = false },
        },
        documentation = {
            auto_show = true,
            auto_show_delay_ms = 0,
        },
    },
    sources = {
        -- Buffer words fall back from LSP/path; LSP snippets use vim.snippet
        -- without enabling a separate snippet collection or provider.
        default = { "lsp", "path", "buffer" },
        per_filetype = {
            lua = { inherit_defaults = true, "lazydev" },
        },
        providers = {
            lazydev = {
                name = "LazyDev",
                module = "lazydev.integrations.blink",
                score_offset = 100,
            },
        },
    },
    signature = {
        enabled = true,
        trigger = { show_on_accept = true },
        window = { show_documentation = false },
    },
    -- Keep this step focused on editing; command-line completion is independent.
    cmdline = { enabled = false },
})
