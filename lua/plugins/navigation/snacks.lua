-- Snacks covers lightweight navigation inside Neovim: pickers search for
-- files, text, and LSP symbols, while the explorer provides a project tree.
-- Project file and text searches rely on `fd` and `rg` from the system PATH.
local Snacks = require("snacks")

-- After manually scrolling a file preview, confirm opens the center of the
-- visible section instead of the item's original position.
local function picker_preview_view(picker, item)
    if not item or item.dir or not picker.preview.win:valid() then
        return
    end

    local preview_item = picker.preview.item
    if not preview_item or preview_item ~= item then
        return
    end

    local preview_buf = vim.api.nvim_win_get_buf(picker.preview.win.win)
    local is_file_preview = picker.opts.preview == nil
        or picker.opts.preview == "file"
        or item.preview == "file"
        or (item.buf and item.buf == preview_buf)
    if not is_file_preview then
        return
    end

    local visible = vim.api.nvim_win_call(picker.preview.win.win, function()
        return { vim.fn.line("w0"), vim.fn.line("w$") }
    end)

    return { item = preview_item, first = visible[1], last = visible[2] }
end

local function picker_preview_scroll(picker, item, down)
    local before = picker_preview_view(picker, item)
    Snacks.picker.actions[down and "preview_scroll_down" or "preview_scroll_up"](picker)
    local after = picker_preview_view(picker, item)

    if after and before and (after.first ~= before.first or after.last ~= before.last) then
        picker._preview_scroll = after
    end
end

local function picker_preview_scroll_up(picker, item)
    picker_preview_scroll(picker, item, false)
end

local function picker_preview_scroll_down(picker, item)
    picker_preview_scroll(picker, item, true)
end

local function picker_confirm(picker, item, action)
    local view = picker_preview_view(picker, item)
    local scroll = picker._preview_scroll
    if view and scroll and scroll.item == view.item and scroll.first == view.first and scroll.last == view.last then
        item.pos = { math.floor((view.first + view.last) / 2), 0 }
    end

    -- Search results should open directly instead of returning to the tree.
    if picker.opts.source == "explorer" and item and picker.input.filter.meta.searching and not item.dir then
        return Snacks.picker.actions.jump(picker, item, action)
    end

    return picker:action("confirm")
end

Snacks.setup({
    explorer = {
        enabled = true,
        -- Opening a directory uses Snacks instead of Neovim's built-in netrw.
        replace_netrw = true,
    },
    picker = {
        enabled = true,
        formatters = {
            file = { filename_first = true },
        },
        actions = {
            picker_confirm = picker_confirm,
            picker_preview_scroll_up = picker_preview_scroll_up,
            picker_preview_scroll_down = picker_preview_scroll_down,
        },
        win = {
            input = {
                keys = {
                    ["<CR>"] = { "picker_confirm", mode = { "i", "n" } },
                    ["<C-u>"] = { "picker_preview_scroll_up", mode = { "i", "n" } },
                    ["<C-d>"] = { "picker_preview_scroll_down", mode = { "i", "n" } },
                },
            },
            list = {
                keys = {
                    ["<CR>"] = "picker_confirm",
                    ["<C-u>"] = "picker_preview_scroll_up",
                    ["<C-d>"] = "picker_preview_scroll_down",
                },
            },
        },
        sources = {
            -- Dotfiles remain visible in the project explorer.
            explorer = {
                hidden = true,
                auto_close = false,
                jump = { close = true },
                layout = {
                    preset = "default",
                    preview = { enabled = true },
                    layout = {
                        backdrop = 60,
                    },
                },
            },
            files = { hidden = true },
            grep = { hidden = true },
            grep_word = { hidden = true },
        },
    },
})

local map = vim.keymap.set

-- File and text discovery ----------------------------------------------------
map("n", "<leader>ff", function()
    Snacks.picker.files()
end, { desc = "Find files" })
map("n", "<leader>fs", function()
    Snacks.picker.grep()
end, { desc = "Search project text" })
map({ "n", "x" }, "<leader>fc", function()
    Snacks.picker.grep_word()
end, { desc = "Search word or selection" })
map("n", "<leader>fr", function()
    Snacks.picker.recent()
end, { desc = "Find recent files" })
map("n", "<leader>fb", function()
    Snacks.picker.buffers({ unloaded = false })
end, { desc = "Find open buffers" })
map("n", "<leader>fg", function()
    Snacks.picker.git_status()
end, { desc = "Find Git changes" })

-- LSP discovery -------------------------------------------------------------
-- These pickers need an attached language server that supports the requested
-- symbol or reference operation.
map("n", "<leader>ss", function()
    Snacks.picker.lsp_symbols()
end, { desc = "Find document symbols" })
map("n", "<leader>sS", function()
    Snacks.picker.lsp_workspace_symbols()
end, { desc = "Find workspace symbols" })
map("n", "<leader>sr", function()
    Snacks.picker.lsp_references()
end, { desc = "Find references" })
map("n", "<leader>sd", function()
    Snacks.picker.lsp_definitions()
end, { desc = "Find definitions" })
map("n", "<leader>st", function()
    Snacks.picker.lsp_type_definitions()
end, { desc = "Find type definitions" })

-- Project tree --------------------------------------------------------------
map("n", "<leader>ew", function()
    Snacks.explorer()
end, { desc = "Open project explorer" })
map("n", "<leader>ef", function()
    Snacks.explorer.reveal()
end, { desc = "Reveal current file" })
