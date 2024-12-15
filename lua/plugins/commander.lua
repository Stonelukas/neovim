return {
    {
        "FeiyouG/commander.nvim",
        dependencies = { "nvim-telescope/telescope.nvim" },
        keys = {
            { "<leader>fC", "<CMD>Telescope commander<CR>", mode = "n" },
        },
        config = function()
            ---@diagnostic disable-next-line: missing-fields
            require("commander").setup({
                components = {
                    "DESC",
                    "KEYS",
                    "CAT",
                },
                sort_by = {
                    "DESC",
                    "KEYS",
                    "CAT",
                    "CMD",
                },
                -- Change the separator used to separate each component
                separator = " ",
                -- When set to true,
                -- The desc component will be populated with cmd if desc is empty or missing.
                auto_replace_desc_with_cmd = true,
                -- Default title of the prompt
                prompt_title = "Commander",
                integration = {
                    telescope = {
                        enable = true,
                        theme = require("telescope.themes").commander,
                    },
                    lazy = {
                        enable = true,
                        set_plugin_name_as_cat = true,
                    },
                },
            })
            require("commander").add({
                components = {
                    "DESC",
                    "KEYS",
                    "CAT",
                },
                sort_by = {
                    "DESC",
                    "KEYS",
                    "CAT",
                    "CMD",
                },
                integration = {
                    telescope = {
                        enable = true,
                        theme = require("telescope.themes").commander,
                    },
                    lazy = {
                        enable = true,
                        set_plugin_name_as_cat = true,
                    },
                },
                {
                    desc = "Search inside current buffer",
                    cmd = "<CMD>Telescope current_buffer_fuzzy_find<CR>",
                    keys = { "n", "<leader>fl" },
                },
                {
                    desc = "Find files",
                    cmd = "<CMD>Telescope find_files<CR>",
                    keys = { "n", "<leader>ff" },
                },
                {
                    -- You can specify multiple keys for the same cmd ...
                    desc = "Show document symbols",
                    cmd = "<CMD>Telescope lsp_document_symbols<CR>",
                    keys = {
                        { "n", "<leader>ds", { noremap = true } },
                    },
                },
                {
                    -- You can also pass in a lua functions as cmd
                    -- NOTE: binding lua funciton to a keymap requires nvim >= 0.7
                    desc = "Run lua function",
                    cmd = function()
                        print("ANONYMOUS LUA FUNCTION")
                    end,
                    keys = { "n", "<leader>alf" },
                },
                -- {
                -- If no cmd is specified, then this entry will be ignored
                -- desc = "lsp run linter",
                -- keys = { "n", "<leader>sf" },
                -- },
            })
        end,
    },
}
