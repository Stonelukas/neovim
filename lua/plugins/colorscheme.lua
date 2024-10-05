return {
    {
        "folke/styler.nvim",
        cond = false,
        config = function()
            require("styler").setup({
                themes = {
                    -- markdown = { colorscheme = "material" },
                    -- help = { colorscheme = "horizon" },
                },
            })
        end,
    },
    {
        "akinsho/horizon.nvim",
        cond = false,
        version = "*",
        priority = 1000,
        opts = {
            plugins = {
                cmp = true,
                indent_blankline = true,
                telescope = true,
                which_key = true,
                barbar = true,
                notify = true,
                symbols_outline = true,
                neo_tree = true,
                gitsigns = true,
                crates = true,
                hop = true,
                navic = true,
                quickscope = true,
                flash = true,
            },
        },
    },
    {
        "miversen33/material.nvim",
        cond = false,
        priority = 1000,
        init = function()
            vim.g.material_style = "deep ocean"
        end,
        config = function()
            require("material").setup({
                contrast = {
                    terminal = false,
                    sidebars = true,
                    floating_windows = false,
                    cursor_line = false,
                    lsp_virtual_text = false,
                    non_current_windows = true,
                    filetypes = {},
                },
                styles = {
                    comments = { italic = true },
                    strings = { bold = true },
                    functions = { bold = true, undercurl = true },
                    variables = {},
                    operators = {},
                    types = {},
                },
                plugins = {
                    -- "coc",
                    -- "colorful-winsep",
                    -- "dap",
                    -- "dashboard",
                    -- "eyeliner",
                    "fidget",
                    -- "flash",
                    "gitsigns",
                    "harpoon",
                    -- "hop",
                    -- "illuminate",
                    -- "indent-blankline",
                    -- "lspsage",
                    "mini",
                    "neogit",
                    "neotest",
                    "neo-tree",
                    "nvim-tree",
                    "noice",
                    "nvim-cmp",
                    "nvim-navic",
                    "nvim-web-devicons",
                    -- "rainbow-delimiters",
                    -- "sneak",
                    "telescope",
                    "trouble",
                    "which-key",
                    "nvim-notify",
                },
                lualine_style = "stealth", -- or default
                async_loading = true,
            })
        end,
    },
    {
        "0xstepit/flow.nvim",
        cond = false,
        priority = 1000,
        config = function()
            require("flow").setup({
                dark_theme = true,
                hight_contrast = false,
                transparent = true,
                fluo_color = "pink",
                agressive_spell = true,
            })
        end,
    },
    {
        "catppuccin/nvim",
        cond = false,
        lazy = false,
        name = "catppuccin",
        priority = 1000,
        config = function()
            require("catppuccin").setup({
                flavour = "mocha",
                transparent_background = false,
                styles = {                   -- Handles the styles of general hi groups (see `:h highlight-args`):
                    comments = { "italic" }, -- Change the style of comments
                },
            })
        end,
    },
    {
        "folke/tokyonight.nvim",
        cond = false,
        lazy = false,
        priority = 1000,
        opts = {},
        config = function()
            require("tokyonight").setup({
                style = "moon",
                light_style = "day",
                transparent = true,
                terminal_colors = true,
                styles = {
                    comments = { italic = true },
                    keywords = { italic = true },
                    sidebars = "normal",
                    floats = "transparent",
                },
                sidebars = { "qf", "help" },
                on_highlights = function(hl, c)
                    local prompt = "#2d3149"
                    hl.TelescopeNormal = {
                        bg = c.bg_dark,
                        fg = c.fg_dark,
                    }
                    hl.TelescopeBorder = {
                        bg = c.bg_dark,
                        fg = c.bg_dark,
                    }
                    hl.TelescopePromptNormal = {
                        bg = prompt,
                    }
                    hl.TelescopePromptBorder = {
                        bg = prompt,
                        fg = prompt,
                    }
                    hl.TelescopePromptTitle = {
                        bg = prompt,
                        fg = prompt,
                    }
                    hl.TelescopePreviewTitle = {
                        bg = c.bg_dark,
                        fg = c.bg_dark,
                    }
                    hl.TelescopeResultsTitle = {
                        bg = c.bg_dark,
                        fg = c.bg_dark,
                    }
                end,
            })
        end,
    },
    {
        "rmehri01/onenord.nvim",
        cond = false,
        config = function()
            require("onenord").setup({
                theme = "dark",  -- "dark" or "light". Alternatively, remove the option and set vim.o.background instead
                borders = true,  -- Split window borders
                fade_nc = false, -- Fade non-current windows, making them more distinguishable
                -- Style that is applied to various groups: see `highlight-args` for options
                styles = {
                    comments = "NONE",
                    strings = "NONE",
                    keywords = "NONE",
                    functions = "NONE",
                    variables = "NONE",
                    diagnostics = "underline",
                },
                disable = {
                    background = false,       -- Disable setting the background color
                    float_background = false, -- Disable setting the background color for floating windows
                    cursorline = false,       -- Disable the cursorline
                    eob_lines = true,         -- Hide the end-of-buffer lines
                },
                -- Inverse highlight for different groups
                inverse = {
                    match_paren = false,
                },
                custom_highlights = {}, -- Overwrite default highlight groups
                custom_colors = {},     -- Overwrite default colors
            })
        end,
    },
}
