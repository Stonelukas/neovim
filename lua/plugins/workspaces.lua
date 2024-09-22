return
{
    'natecraddock/workspaces.nvim',
    config = function()

        require('workspaces').setup {
            cd_type = 'global', -- or 'local', 'global'
            auto_open = false,
            auto_dir = true,
            hooks = {
                open_pre = function()
                    require('resession').save(vim.fn.getcwd(), { notify = true })
                    vim.cmd([[%bd]])
                end,
                open = {
                    function()
                        require('resession').load(vim.fn.getcwd(), { notify = true })
                    end,
                },
            },
        }
    end
}
