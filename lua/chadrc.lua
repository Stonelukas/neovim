local M = {}

-- M.base46 = {
--     theme = "onedark",
--     transparency = true,
--     hl_override = {
--         Pmenu = { bg = "black2" },
--         Normal = {
--             bg = { "black2", -4 },
--         },
--     },
-- }

M.ui = {
    -- cmp = {
    --     icons = true,
    --     icons_left = true,
    --     lspkind_text = true,
    --     style = "atom",
    -- },
    -- telescope = { style = "bordered" },

    -- statusline = {
    --     theme = "minimal",
    --     separator_style = "round",
    --     order = {
    --         "mode",
    --         "file",
    --         "git",
    --         "diagnostics",
    --         "%=",
    --         "lsp",
    --         "%=",
    --         "cursor",
    --         "cwd",
    --     },
    -- },
    tabufline = {
        order = { "treeOffset", "buffers", "tabs", "btns" },
        enabled = true,
        lazyload = true,
        modules = {},
    },
}

return M
