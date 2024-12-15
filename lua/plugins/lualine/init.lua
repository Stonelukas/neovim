return {
    {
        "nvim-lualine/lualine.nvim",
        enabled = false,
        config = function()
            -- config
            require("plugins.lualine.config")
        end,
    },
}
