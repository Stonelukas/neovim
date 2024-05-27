return {
    {
        "romgrk/barbar.nvim",
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
                tabpages = false,
                icons = {
                    -- Configure the base icons on the bufferline.
                    -- Valid options to display the buffer index and -number are `true`, 'superscript' and 'subscript'
                    buffer_index = false,
                    buffer_number = false,
                    button = "",
                    -- Enables / disables diagnostic symbols
                    diagnostics = {
                        [vim.diagnostic.severity.ERROR] = { enabled = true, icon = "ﬀ" },
                        [vim.diagnostic.severity.WARN] = { enabled = true },
                        [vim.diagnostic.severity.INFO] = { enabled = true },
                        [vim.diagnostic.severity.HINT] = { enabled = true },
                    },
                    gitsigns = {
                        added = { enabled = true, icon = "+" },
                        changed = { enabled = true, icon = "~" },
                        deleted = { enabled = true, icon = "-" },
                    },
                    modified = { button = "●" },
                    pinned = { button = "", filename = true },
                    alternate = { filetype = { enabled = false } },
                    current = { buffer_index = true },
                    inactive = { button = "×" },
                    visible = { modified = { buffer_number = false } },
                },
            })
        end,
    },
}
