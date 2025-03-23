return {
    {
        "francescarpi/buffon.nvim",
        opts = {
            cyclic_navigation = true,
            keybindings = {
                goto_next_buffer = "<tab>",
                goto_prev_buffer = "<s-tab>",
                previous_page = "s-ä",
                next_page = "s-ö",
            },
        },
        dependencies = {
            "nvim-tree/nvim-web-devicons",
            "nvim-lua/plenary.nvim",
        },
    },
    {
        "jackMort/tide.nvim",
        opts = {
            -- optional configuration
            keys = {
                leader = "ä",
                panel = "ä",
            }
        },
        dependencies = {
            "MunifTanjim/nui.nvim",
            "nvim-tree/nvim-web-devicons",
        },
    },
}
