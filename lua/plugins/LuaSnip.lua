--   https://github.com/L3MON4D3/LuaSnip
return {
    "L3MON4D3/LuaSnip",
    build = "make install_jsregexp",
    dependencies = {
        "saadparwaiz1/cmp_luasnip",
        "rafamadriz/friendly-snippets",
        "honza/vim-snippets",
    },
    config = function()
        require("plugins.completion.snippets")
    end
}
