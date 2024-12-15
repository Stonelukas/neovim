return {
    {
        "hrsh7th/nvim-cmp",
        lazy = false,
        priority = 100,
        event = { "InsertEnter", "CmdlineEnter" },
        dependencies = {
            "onsails/lspkind.nvim",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-nvim-lua",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-buffer",
            "exafunction/codeium.vim",
            {
                "L3MON4D3/LuaSnip",
                build = "make install_jsregexp",
                dependencies = {
                    "saadparwaiz1/cmp_luasnip",
                    "rafamadriz/friendly-snippets",
                    "honza/vim-snippets",
                },
            },

            "saadparwaiz1/cmp_luasnip",
            "rasulomaroff/cmp-bufname",
            "lukas-reineke/cmp-rg",
            "amarakon/nvim-cmp-buffer-lines",
            "hrsh7th/cmp-cmdline",
            "petertriho/cmp-git",
            "nvim-tree/nvim-web-devicons",
            "Shougo/deol.nvim",
            "hrsh7th/cmp-nvim-lsp-signature-help",
            "onsails/diaglist.nvim",
        },
        config = function()
            require("custom.completion")
        end,
    },
    {
        "tamago324/cmp-zsh",
        config = function()
            require("cmp_zsh").setup({ zshrc = true, filetypes = { "deoledit", "zsh" } })
        end,
    },
    {
        "L3MON4D3/LuaSnip",
        build = "make install_jsregexp",
        dependencies = { "saadparwaiz1/cmp_luasnip", "rafamadriz/friendly-snippets" },
        config = function()
            require("custom.luasnip")
        end,
    },
}
