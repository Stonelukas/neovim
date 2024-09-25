return {
    {
        "romgrk/barbar.nvim",
        enabled = true,
        dependencies = {
            "lewis6991/gitsigns.nvim", -- OPTIONAL: for git status
            "nvim-tree/nvim-web-devicons", -- OPTIONAL: for file icons
        },
        init = function()
            vim.g.barbar_auto_setup = false
        end,
        opts = {
            -- lazy.nvim will automatically call setup for you. put your options here, anything missing will use the default:
            -- animation = true,
            -- insert_at_start = true,
            -- …etc.
        },
        config = function()
            vim.g.barbar_auto_setup = true -- disable auto-setup

            require("barbar").setup({
                animation = true,
                tabpages = true,
                clickable = true,
                icons = {
                    -- Configure the base icons on the bufferline.
                    -- Valid options to display the buffer index and -number are `true`, 'superscript' and 'subscript'
                    buffer_index = false,
                    buffer_number = false,
                    button = "",
                    -- Enables / disables diagnostic symbols
                    diagnostics = {
                        [vim.diagnostic.severity.ERROR] = { enabled = true, icon = " " },
                        [vim.diagnostic.severity.WARN] = { enabled = true },
                        [vim.diagnostic.severity.INFO] = { enabled = true },
                        [vim.diagnostic.severity.HINT] = { enabled = true },
                    },
                    gitsigns = {
                        added = { enabled = true, icon = " " },
                        changed = { enabled = true, icon = "󱗝 " },
                        deleted = { enabled = true, icon = "󰆴 " },
                    },
                    modified = { button = "●" },
                    pinned = { button = "", filename = true },
                    -- preset = "default",
                    alternate = { filetype = { enabled = false } },
                    current = { buffer_index = true },
                    inactive = { button = "×" },
                    visible = { modified = { buffer_number = false } },
                },
                insert_at_end = true,
                sidebar_filetypes = {
                    undotree = {
                        text = "undotree",
                        align = "center",
                    },
                    ["neo-tree"] = {
                        event = "BufWipeout",
                    },
                    outline = {
                        event = "BufWinLeave",
                        text = "symbols-outline",
                        align = "right",
                    },
                },
            })
        end,
    },
}
