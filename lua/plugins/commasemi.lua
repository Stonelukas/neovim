--   https://github.com/saifulapm/chartoggle.nvim
return {
    {
        "saifulapm/commasemi.nvim",
        event = "BufEnter",
        opts = {
            leader = "<leader>",
            keymaps = true,
            commands = true,
        },
    },
    {
        "saifulapm/chartoggle.nvim",
        enabled = false,
        event = "BufEnter",
        opts = {
            leader = "<leader>",
            keys = { ",", ";" }
        },
        keys = { "<leader>,", "<leader>;", }
    }
}
