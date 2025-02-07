---@module "lazy"
---@type LazySpec
return {
    {
        "folke/lazydev.nvim",
        ft = "lua",
        cmd = "LazyDev",
        dependencies = {
            { "Bilal2453/luvit-meta", lazy = true }
        },
        opts = {
            library = {
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
                { path = "luvit-meta/library", words = { "vim%.uv" } }
            },
        },
    },
}
