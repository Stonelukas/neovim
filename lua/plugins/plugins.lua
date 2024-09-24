return {
    {
        'roobert/activate.nvim',
        keys = {
            {
                '<leader>a',
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
        config = function()
            require('scope').setup {
                  hooks = {
                    pre_tab_leave = function()
                    vim.api.nvim_exec_autocmds('User', {pattern = 'ScopeTabLeavePre'})
                    -- [other statements]
                    end,

                    post_tab_enter = function()
                    vim.api.nvim_exec_autocmds('User', {pattern = 'ScopeTabEnterPost'})
                    -- [other statements]
                    end,

                    -- [other hooks]
                },
            }

        end
    },
    {
        'jlanzarotta/bufexplorer',
    },
}
