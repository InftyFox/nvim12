-- C# files use the `cs` filetype, but the installed parser is `c_sharp`.
vim.treesitter.language.register("c_sharp", "cs")

-- Keep the built-in syntax highlighting until the optional parser is installed.
-- No parser is downloaded or compiled during startup.
vim.api.nvim_create_autocmd("FileType", {
    pattern = "cs",
    desc = "Enable C# Treesitter highlighting when its parser is installed",
    callback = function(args)
        if vim.treesitter.language.add("c_sharp") then
            vim.treesitter.start(args.buf, "c_sharp")
        end
    end,
})
