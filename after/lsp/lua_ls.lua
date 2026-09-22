-- Local extension for nvim-lspconfig's `lua_ls` profile. Files under
-- `after/lsp/` are discovered and merged by Neovim, which keeps local settings
-- separate from the reusable server defaults. See `:help lsp-config`.
return {
    on_init = function(client)
        -- Neovim's globals and runtime modules are relevant to this config, but
        -- injecting them into every Lua project would hide missing dependencies.
        -- Normalize both paths so equivalent path spellings compare reliably.
        local workspace = client.workspace_folders and client.workspace_folders[1]
        if not workspace or vim.fs.normalize(workspace.name) ~= vim.fs.normalize(vim.fn.stdpath("config")) then
            return
        end

        -- Preserve settings from the base profile and override only the values
        -- needed when editing Neovim configuration written for LuaJIT.
        client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua or {}, {
            runtime = {
                version = "LuaJIT",
                path = {
                    "lua/?.lua",
                    "lua/?/init.lua",
                },
            },
            workspace = {
                -- Do not ask how third-party libraries should be configured;
                -- Neovim's own runtime is the only additional library here.
                checkThirdParty = false,
                library = { vim.env.VIMRUNTIME },
            },
        })
    end,
    settings = {
        Lua = {},
    },
}
