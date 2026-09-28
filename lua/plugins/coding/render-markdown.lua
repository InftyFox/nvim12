-- Render Markdown in all modes, including insert mode, for Markdown files only.
-- :RenderMarkdown toggle switches the rendering on or off when needed.
require("render-markdown").setup({
    completions = { lsp = { enabled = true } },
    render_modes = true,
    code = {
        width = "block",
        left_pad = 4,
        right_pad = 4,
        border = "thick",
    },
    heading = {
        width = { "full", "block", "block", "block", "block", "block" },
        min_width = 120,
        right_pad = 2,
        left_pad = 2,
        border = true,
        icons = { "󰉫 ", "󰉬 ", "󰉭 ", "󰉮 ", "󰉯 ", "󰉰 " },
    },
    indent = {
        enabled = true,
        render_modes = false,
        per_level = 4,
        skip_level = 1,
        skip_heading = true,
        icon = "",
        priority = 0,
        highlight = "RenderMarkdownIndent",
    },
    callout = {
        note = { rendered = "󱇗 Note" },
        warning = { rendered = " Warning" },
        info = { rendered = " Info" },
        todo = { rendered = " Todo" },
        danger = { rendered = " Danger" },
        error = { rendered = " Error" },
    },
})
