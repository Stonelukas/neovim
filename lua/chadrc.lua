local M = {}

M.base46 = {
    theme = "onedark",
    transparency = true,
    hl_override = {
        Pmenu = { bg = "black2" },
        Normal = {
            bg = { "black2", -4 },
        },
    },
}

M.ui = {
    cmp = {
        icons = true,
        icons_left = true,
        lspkind_text = true,
        style = "atom",
    },
    telescope = { style = "bordered" },

    statusline = {
        theme = "minimal",
        separator_style = "round",
        order = {
            "mode",
            "file",
            "git",
            "diagnostics",
            "%=",
            "lsp",
            "%=",
            "cursor",
            "cwd",
        },

    },
    tabufline = {
        order = { "treeOffset", "buffers", "tabs", "btns" },
        enabled = true,
        lazyload = true,
        modules = {},
    },
}

M.term = {
    winopts = { number = false },
    sizes = { sp = 0.3, vsp = 0.2, ["bo sp"] = 0.3, ["bo vsp"] = 0.2 },
    float = {
        row = 0.3,
        col = 0.25,
        width = 0.5,
        height = 0.4,
        border = "single",
    },
}

return M
