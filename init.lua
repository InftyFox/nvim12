-- Neovim loads this file first. Keeping it as a small table of contents makes
-- the startup order explicit while the implementation stays in focused modules.

-- Core behavior is configured before plugins are registered. In particular,
-- the leader keys must exist before any plugin modules define their mappings.
require("config.options")
require("config.autocmds")
require("config.keymaps")

-- `vim.pack.add()` makes the plugins available before their setup modules run.
require("config.packages")

-- Plugin setup is grouped by purpose rather than by startup phase.
require("plugins.ui.rose-pine")
require("plugins.ui.mini-icons")
require("plugins.navigation.snacks")
require("plugins.navigation.yazi")

-- Language tooling is last because it builds on the general editor behavior
-- and on plugins registered above. Conform owns formatting policy separately.
require("config.lsp")
require("plugins.coding.conform")
require("plugins.coding.render-markdown")
require("plugins.coding.mini-ai")
