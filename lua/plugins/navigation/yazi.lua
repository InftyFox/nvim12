-- Yazi complements the in-editor Snacks explorer with a full terminal file
-- manager for moving, renaming, and selecting files. The `yazi` executable must
-- be available on the system PATH.
local yazi = require("yazi")

---@type YaziConfig | {}
yazi.setup({
    -- Do not take over directory buffers; Snacks remains the default explorer.
    open_for_directories = false,
    -- Yazi may navigate elsewhere, but closing it must not silently change
    -- Neovim's project root or expose a key that performs that change.
    change_neovim_cwd_on_close = false,
    keymaps = {
        replace_in_directory = false,
        change_working_directory = false,
    },
    integrations = {
        -- Hand directory and selected-file searches back to the same picker
        -- interface used by the rest of this configuration.
        grep_in_directory = "snacks.picker",
        grep_in_selected_files = "snacks.picker",
    },
})

local map = vim.keymap.set

-- Open beside the current file (or visual selection) for local operations.
map({ "n", "x" }, "<leader>yf", function()
    yazi.yazi()
end, { desc = "Open Yazi at current file" })
-- Open at Neovim's working directory when the task concerns the whole project.
map("n", "<leader>yw", function()
    yazi.yazi({}, vim.fn.getcwd())
end, { desc = "Open Yazi at working directory" })
