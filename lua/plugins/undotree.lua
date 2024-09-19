return {
    'mbbill/undotree',
    keys = {
        {
            '<F5>',
            function()
                return vim.cmd 'UndotreeToggle'
            end,
            desc = 'Undotree',
        },
    },
    init = function()
        vim.g.undotree_WindowLayout = 2
        vim.g.undotree_SetFocusWhenToggle = 1
    end
}
