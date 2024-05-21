return {
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.6",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            local builtin = require("telescope.builtin")
            vim.keymap.set("n", "<C-p>", function()
                require("telescope.builtin").find_files({ previewer = true })
            end)
            vim.keymap.set("n", "<leader>fg", function()
                require("telescope.builtin").live_grep({})
            end)
            vim.keymap.set("n", "<leader>fh", function()
                require("telescope.builtin").help_tags({})
            end)
            vim.keymap.set("n", "<leader>ft", function()
                require("telescope.builtin").tags({})
            end)
            vim.keymap.set("n", "<leader><leader>", function()
                require("telescope.builtin").oldfiles({})
            end)
            vim.keymap.set("n", "<leader>bu", function()
                require("telescope.builtin").buffers({ sort_lastused = true })
            end)
            vim.keymap.set("n", "<leader>cb", function()
                require("telescope.builtin").current_buffers_fuzzy_find({})
            end)
        end,
    },
    {
        "nvim-telescope/telescope-ui-select.nvim",
        config = function()
            require("telescope").setup({
                extensions = {
                    ["ui-select"] = {
                        require("telescope.themes").get_dropdown({}),
                    },
                },
            })
            require("telescope").load_extension("ui-select")
        end,
    },

    {
        "nvim-telescope/telescope-fzf-native.nvim",
        -- NOTE: If you have trouble with this installation, refer to the README for telescope-fzf-native.
        build = "make",
        config = function()
            require("telescope").load_extension("fzf")
        end,
    },
}
