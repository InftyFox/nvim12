local config_root = vim.fs.normalize(vim.fn.stdpath("config"))

-- Only this Neovim workspace receives runtime/plugin libraries. Bundled local
-- plugins share its root; add separate plugin repositories only when needed.
require("lazydev").setup({
    enabled = function(root)
        return vim.fs.normalize(root) == config_root
    end,
    integrations = { cmp = false },
})
