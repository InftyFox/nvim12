-- Configure the palette before activating it so the first rendered colorscheme
-- already uses these choices. The package itself is registered in packages.lua.
require("rose-pine").setup({
    variant = "moon",
    dark_variant = "moon",
    disable_background = false,
})

-- `setup()` only defines the theme; `:colorscheme` applies it to the editor.
vim.cmd.colorscheme("rose-pine")
