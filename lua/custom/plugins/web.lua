return {
    {
        "vuki656/package-info.nvim",
        config = function()
            require("package-info").setup({
                package_manager = "pnpm",
            })
        end,
    },
    {
        'dmmulroy/tsc.nvim',
        config = function()
            require("tsc").setup()
        end
    }
}
