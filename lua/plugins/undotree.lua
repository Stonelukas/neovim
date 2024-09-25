return {
    'mbbill/undotree',
    keys = {
        {
            '<leader>u',
            '<cmd>UndotreeShow<cr>',
            desc = 'Undotree',
        },
    },
    init = function()
        vim.g.undotree_WindowLayout = 2
        vim.g.undotree_SetFocusWhenToggle = 1
    end
}