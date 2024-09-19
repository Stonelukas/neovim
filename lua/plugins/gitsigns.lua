--   https://github.com/lewis6991/gitsigns.nvim
--   TODO: trouble.nvim integration
return {
    "lewis6991/gitsigns.nvim",
    config = function()
        require('gitsigns').setup {
            on_attach = function(bufnr)
                local gitsigns = require('gitsigns')

                local function map(mode, l, r, opts)
                    opts = opts or {}
                    opts.buffer = bufnr
                    vim.keymap.set(mode, l, r, opts)
                end

                -- Actions
                map('n', '<leader>gs', gitsigns.stage_hunk, { desc = 'stage hunk'})
                map('n', '<leader>gr', gitsigns.reset_hunk, { desc = 'reset hunk'})
                map('v', '<leader>gs', function()
                    gitsigns.stage_hunk { vim.fn.line('.'), vim.fn.line('v') }
                end, { desc = 'stage hunk Visual '})
                map('v', '<leader>gr', function()
                    gitsigns.reset_hunk { vim.fn.line('.'), vim.fn.line('v') }
                end, { desc = 'reset hunk Visual'})
                map('n', '<leader>gS', gitsigns.stage_buffer,{ desc = 'stage buffer'})
                map('n', '<leader>gu', gitsigns.undo_stage_hunk,{ desc = 'undo stage hunk'} )
                map('n', '<leader>gR', gitsigns.reset_buffer,{ desc = 'reset buffer'} )
                map('n', '<leader>gp', gitsigns.preview_hunk,{ desc = 'preview hunk'} )
                map('n', '<leader>gb', function()
                    gitsigns.blame_line { full = true }
                end,{ desc = 'full blame'} )
                map('n', '<leader>gtb', gitsigns.toggle_current_line_blame,{ desc = 'toggle line blame'} )
                map('n', '<leader>gd', gitsigns.diffthis, { desc = 'Diff' } )
                map('n', '<leader>gD', function()
                    gitsigns.diffthis('~')
                end, { desc = 'Diff to HEAD'})
                map('n', '<leader>gtd', gitsigns.toggle_deleted,{ desc = 'toggle deleted'} )

                -- Text object
                map({'o', 'x' }, 'ih', '<cmd><C-u>Gitsigns select_hunk<cr>', { desc = 'select hunk'} )
            end
        }
    end
}
