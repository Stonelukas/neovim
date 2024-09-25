return {
    'roobert/activate.nvim',
    keys = {{
        '<leader>a',
        function()
            require('activate').list_plugins()
        end,
        desc = 'Plugins'
    }}
}
