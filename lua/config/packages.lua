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
    { src = "https://github.com/folke/lazydev.nvim", name = "lazydev.nvim" },
    {
        src = "https://github.com/saghen/blink.cmp",
        name = "blink.cmp",
        version = "v1.10.2",
    },
    { src = "https://github.com/stevearc/conform.nvim", name = "conform.nvim" },
    { src = "https://github.com/nvim-mini/mini.icons", name = "mini.icons" },
    { src = "https://github.com/nvim-mini/mini.ai", name = "mini.ai" },
    { src = "https://github.com/nvim-mini/mini.pairs", name = "mini.pairs" },
    { src = "https://github.com/nvim-mini/mini.surround", name = "mini.surround" },
    { src = "https://github.com/nvim-treesitter/nvim-treesitter", name = "nvim-treesitter" },
    {
        src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects",
        name = "nvim-treesitter-textobjects",
        version = "main",
    },
    { src = "https://github.com/nvim-treesitter/nvim-treesitter-context", name = "nvim-treesitter-context" },
    { src = "https://github.com/MeanderingProgrammer/render-markdown.nvim", name = "render-markdown.nvim" },
})
