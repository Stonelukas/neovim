local lualine = require('lualine')

local colors = {
    yellow = "#ECBE7B",
    cyan = "#008080",
    darkblue = "#081633",
    green = "#98be65",
    orange = "#FF8800",
    violet = "#a9a1e1",
    magenta = "#c678dd",
    blue = "#51afef",
    red = "#ec5f67",
}

local config = {
    options = {
        theme = 'auto',
        globalstatus = true,
    },
    sections = {
        lualine_a = {
            {
                'mode',
                icons_enabled = true,
            },
        },
        lualine_b = {
            {
                'branch',
                icon = '',
                color = { fg = colors.green },
            },
            {
                'diff', 
                colored = true,
                -- diff_color = {
                --     added = 'LuaLineDiffAdd',
                --     modified = 'LuaLineDiffChanged',
                --     removed = 'LuaLineDiffDelete'
                -- },
                symbols = {
                    added = " ",
                    modified = " ",
                    removed = " ",
                },
                color = { fg = colors.orange },
            },
            -- TODO: diagnostics - lsp
            -- TODO: noice
        },
        lualine_c = {
            {
                'windows',
                color = { fg = '#7e9cd8' },
            },
        },
    },
}

lualine.setup(config)
