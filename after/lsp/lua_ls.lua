return {
    on_init = function(client)
        local workspace = client.workspace_folders and client.workspace_folders[1]
        if not workspace or vim.fs.normalize(workspace.name) ~= vim.fs.normalize(vim.fn.stdpath("config")) then
            return
        end

        client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua or {}, {
            runtime = {
                version = "LuaJIT",
                path = {
                    "lua/?.lua",
                    "lua/?/init.lua",
                },
            },
            workspace = {
                checkThirdParty = false,
                library = { vim.env.VIMRUNTIME },
            },
        })
    end,
    settings = {
        Lua = {},
    },
}
