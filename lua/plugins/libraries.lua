return {
    {
        "miversen33/netman.nvim",
        opts = {},
        config = true,
    },
    {
        "stevearc/dressing.nvim",
        priority = 1000,
        config = function()
            require("dressing").setup({
                prompt_align = "center",
                default_prompt = "> ",
                relative = "editor",
                prefer_width = 50,
                select = {
                    get_config = function(opts)
                        if opts.kind == "codeaction" then
                            return {
                                backend = "nui",
                                nui = {
                                    relative = "cursor",
                                    max_width = 40,
                                },
                            }
                        end
                    end,
                },
            })
        end,
    },
    { "nvim-lua/plenary.nvim" },
    { "nvim-tree/nvim-web-devicons" },
    { "muniftanjim/nui.nvim" },
    {
        "grapp-dev/nui-components.nvim",
        version = false,
        dependencies = {
            "MunifTanjim/nui.nvim",
        },
    },
    { "kkharji/sqlite.lua",                     module = "sqlite" },
    { "nvim-lua/popup.nvim" },
    { "adoyle-h/telescope-extension-maker.nvim" },
    {
        "sindrets/diffview.nvim",
        cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" },
        config = true,
    },
    { "anuvyklack/middleclass" },
    { "anuvyklack/animation.nvim" },
    {
        "echasnovski/mini.nvim",
        version = false,
        config = function()
            require("mini.move").setup()
        end,
    },
}
