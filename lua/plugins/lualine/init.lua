return {
    {
        "nvim-lualine/lualine.nvim",
        cond = false,
        config = function()
            -- config
            require("plugins.lualine.config")
        end,
    },
}
