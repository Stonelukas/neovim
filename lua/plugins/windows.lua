--   https://github.com/sindrets/winshift.nvim
--   https://github.com/mrjones2014/smart-splits.nvim
return {
    {
        "sindrets/winshift.nvim",
        config = function()
            require('winshift').setup {}
        end
    },
    {
        'mrjones2014/smart-splits.nvim',
        config = function()

            require('smart-splits').setup {
                ignored_filetypes = { 'neo-tree' },
                resize_mode = {
                    hooks = {
                        on_leave = require('bufresize').register,
                    },
                },
            }
        end
    },
    {
        'kwkarlwang/bufresize.nvim',
        config = function()
            -- TODO: Toggleterm
			local function opts(desc)
				return { desc = "" .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
			end
            require('bufresize').setup {
                register = {
                    keys = {
                        { 'n', '<leader>w<', '20<C-w><', opts('Decrease width') },
                        { 'n', '<leader>w>', '20<C-w>>', opts('Increase width') },
                        { 'n', '<leader>w+', '2<C-w>+', opts('Increase height') },
                        { 'n', '<leader>w-', '2<C-w>-', opts('Increase height') },
                        { 'n', '<leader>w_', '<C-w>_', opts('Increase height to max') },
                        { 'n', '<leader>w=', '<C-w>=', opts('Equal height and width') },
                        { 'n', '<leader>w|', '<C-w>|', opts('Increase width to max') },
                        { 'n', '<leader>wO', '<C-w>|<C-w>_', opts('Increase width and hight to max') },
                    },
                    trigger_events = { 'BufWinEnter', 'WinEnter' },
                },
                resize = {
                    keys = {},
                    trigger_events = { 'VimResized' },
                    increment = false,
                },
            }
        end
    },
    {
        'anuvyklack/windows.nvim',
        config = function()
            vim.o.winwidth = 10
            vim.o.winminwidth = 10
            vim.o.equalalways = false
            require('windows').setup{}
        end
    },
}
