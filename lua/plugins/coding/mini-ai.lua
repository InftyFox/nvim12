-- Extend a/i text objects without taking over the built-in g] tag command.
-- an/in deliberately use mini.ai's next-object search instead of Neovim's
-- incremental Treesitter selection.
require("mini.ai").setup({
    mappings = {
        goto_left = "",
        goto_right = "",
    },
})
