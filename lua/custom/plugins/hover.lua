return {
    {
        "lewis6991/hover.nvim",
        config = function()
            require("hover").setup({
                init = function()
                    -- Require providers
                    require("hover.providers.lsp")
                    require("hover.providers.gh")
                    -- require "hover.providers.terraform"
                    -- require "hover.providers.ansible"
                    -- require("hover.providers.grep")
                    require("hover.providers.man")
                    require("hover.providers.dictionary")
                end,
                preview_opts = {
                    border = "rounded",
                },
                preview_window = true,
                -- Whether the contents of a currently open hover window should be moved to a :h preview-window when pressing the hover keymap
                title = true,

                mouse_providers = {
                    "LSP",
                },
                mouse_delay = 1000,
            })

            -- Setup keymaps
            vim.keymap.set("n", "<leader>lK", require("hover").hover, { desc = "hover.nvim" })
            vim.keymap.set("n", "gK", require("hover").hover_select, { desc = "hover.nvim (select)" })
            vim.keymap.set("n", "<A-m>", function()
                require("hover").hover_switch("previous")
            end, { desc = "hover.nvim (previous source)" })
            vim.keymap.set("n", "<A-n>", function()
                require("hover").hover_switch("next")
            end, { desc = "hover.nvim (next source)" })

            -- Mouse support
            --[[ vim.keymap.set("n", "<MouseMove>", require("hover").hover_mouse, { desc = "hover.nvim (mouse)" })
			vim.o.mousemoveevent = true ]]
        end,
    },
}
