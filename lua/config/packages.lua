-- `vim.pack` is Neovim's built-in package manager. It installs missing plugins
-- on first use and loads the registered packages so later `require()` calls work.
-- See `:help vim.pack` and `:help vim.pack.add()`.
--
-- Exact revisions are recorded in `nvim-pack-lock.json`. Use
-- `:lua vim.pack.update()` to review and apply plugin updates deliberately.
vim.pack.add({
    -- Keep registration here and plugin-specific behavior in `lua/plugins/`.
    { src = "https://github.com/rose-pine/neovim", name = "rose-pine" },
    { src = "https://github.com/folke/snacks.nvim", name = "snacks.nvim" },
    { src = "https://github.com/nvim-lua/plenary.nvim", name = "plenary.nvim" },
    { src = "https://github.com/mikavilpas/yazi.nvim", name = "yazi.nvim" },
    { src = "https://github.com/neovim/nvim-lspconfig", name = "nvim-lspconfig" },
    { src = "https://github.com/stevearc/conform.nvim", name = "conform.nvim" },
    { src = "https://github.com/nvim-mini/mini.icons", name = "mini.icons" },
    { src = "https://github.com/MeanderingProgrammer/render-markdown.nvim", name = "render-markdown.nvim" },
})
