return {
    "mbbill/undotree",
    keys = {
        {
            "<leader>U",
            "<cmd>UndotreeShow<cr>",
            desc = "Undotree",
        },
    },
    cmd = "UndotreeToggle",
    init = function()
        vim.g.undotree_WindowLayout = 2
        vim.g.undotree_SetFocusWhenToggle = 1
    end,
}
