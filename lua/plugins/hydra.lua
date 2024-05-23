return {
    {
        "nvimtools/hydra.nvim",
        config = function()
            local Hydra = require("hydra")
            require("hydra").setup({
                debug = false,
                exit = false,
                foreign_keys = nil,
                color = "red",
                timeout = false,
                invoke_on_body = false,
                hint = {
                    show_name = true,
                    position = { "bottom" },
                    offset = 0,
                    float_opts = {},
                },
                on_enter = nil,
                on_exit = nil,
                on_key = nil,
            })
        end,
    },
}
