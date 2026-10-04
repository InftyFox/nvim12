-- Extend a/i text objects without taking over the built-in g] tag command.
-- an/in deliberately use mini.ai's next-object search instead of Neovim's
-- incremental selection. Preserve the native callbacks before setup replaces
-- them, including their LSP fallback when no Treesitter parser is available.
local function copy_selection_mapping(from, to)
    local mapping = vim.fn.maparg(from, "x", false, true)
    vim.keymap.set("x", to, mapping.callback or mapping.rhs, { desc = mapping.desc })
end

copy_selection_mapping("an", "<leader>ls")
copy_selection_mapping("in", "<leader>lS")

local ai = require("mini.ai")
ai.setup({
    custom_textobjects = {
        -- Use the language queries supplied by nvim-treesitter-textobjects.
        F = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
    },
    mappings = {
        goto_left = "",
        goto_right = "",
    },
})
