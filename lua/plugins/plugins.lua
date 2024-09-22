return {
    {
        'roobert/activate.nvim',
        keys = {
            {
                '<leader>lp',
                function()
                    require('activate').list_plugins()
                end,
                desc = 'Plugins',
            },
        },
    },
    {
        'tiagovla/scope.nvim',
        opts = {},
    },
    {
        'jlanzarotta/bufexplorer',
    },
}
