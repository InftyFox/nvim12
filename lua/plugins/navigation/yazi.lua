local yazi = require("yazi")

yazi.setup({
    open_for_directories = false,
    change_neovim_cwd_on_close = false,
    keymaps = {
        replace_in_directory = false,
        change_working_directory = false,
    },
    integrations = {
        grep_in_directory = "snacks.picker",
        grep_in_selected_files = "snacks.picker",
    },
})

local map = vim.keymap.set

map({ "n", "x" }, "<leader>yf", function()
    yazi.yazi()
end, { desc = "Open Yazi at current file" })
map("n", "<leader>yw", function()
    yazi.yazi({}, vim.fn.getcwd())
end, { desc = "Open Yazi at working directory" })
