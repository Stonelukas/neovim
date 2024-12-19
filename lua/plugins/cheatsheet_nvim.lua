--   https://github.com/doctorfree/cheatsheet.nvim
return {
    {
        "dbeniamine/cheat.sh-vim",
    },
    {
        "lifepillar/vim-cheat40",
    },
    {
        "doctorfree/cheatsheet.nvim",
        event = "VeryLazy",
        config = function()
            local ctactions = require("cheatsheet.telescope.actions")

            require("cheatsheet").setup({
                -- bundled_cheatsheet = {
                --     enabled = { "default", "nerd-fonts", "lua", "makrdown", "netrw", "unicode" },
                -- },
                bundled_cheatsheets = true,
                bundled_plugin_cheatsheets = {
                    "goto-preview",
                        -- TODO:
                        -- "octo.nvim",
                    "gitsigns",
                    "telescope.nvim",
                },
                include_only_installed_plugins = false,
                telescope_mappings = {
                    ["<cr>"] = ctactions.select_or_fill_commandline,
                    ["<leader><cr>"] = ctactions.select_or_execute,
                    ["<C-Y>"] = ctactions.copy_cheat_value,
                    ["<C-E>"] = ctactions.edit_user_cheatsheet,
                },
            })
        end,
    }
}
