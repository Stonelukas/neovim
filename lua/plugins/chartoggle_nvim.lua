--   https://github.com/saifulapm/chartoggle.nvim
return {
    "saifulapm/chartoggle.nvim",
    event = "BufEnter",
    opts = {
        leader = "<leader>",
        keys = { ",", ";" }
    },
    keys = { "<leader>,", "<leader>;", }
}
