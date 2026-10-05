-- Local extension for nvim-lspconfig's `lua_ls` profile. Files under
-- `after/lsp/` are discovered and merged by Neovim, which keeps local settings
-- separate from the reusable server defaults. See `:help lsp-config`.
-- lazydev supplies LuaJIT/runtime/plugin settings only for the Neovim workspace;
-- ordinary Lua projects retain LuaLS defaults and their project configuration.
return {
    settings = {
        Lua = {},
    },
}
