return
{
    'folke/which-key.nvim',
    cond = true,
    event = 'VeryLazy',
    keys = {
        {
            '<leader>Hl', 
            function()
                require('which-key').show { global = false }
            end,
            desc = "Buffer Local Keymaps (which-key)",
        },
        {
            '<leader>Hg', 
            function()
                require('which-key').show { global = true }
            end,
            desc = "Buffer Global Keymaps (which-key)"
        },
    },
    init = function()
        vim.o.timeout = true
        vim.o.timeoutlen = 300
    end,
    config = function()
        local wk = require('which-key')

        wk.setup {
            preset = 'modern',
            notify = true,
            defer = function(ctx)
                if vim.list_contains({ "d", "y" }, ctx.operator) then
                    return true
                end
                return vim.list_contains({ "<C-V>", "V" }, ctx.mode)
            end,
            triggers = {
                { '<auto>', mode = 'nixotc' },
            },
            plugins = {
                marks = true,
                spelling = {
                    enabled = true,
                },
                presets = {
                    operators = true,
                    motions = true,
                    text_objects = true,
                    windows = true,
                    nav = true,
                    z = true,
                    g = true,
                },
            },
            win = { 
                no_overlap = false,
            },
        }

        wk.add {
            { '<leader>', group = 'Leader' },
            { '<leader>f', group = 'Telescope' },
            { '<leader>b', group = 'Buffers' },
            { '<leader>d', group = 'Definitions' },
            { '<leader>t', group = 'Todo-comments' },
            { '<leader>s', group = 'Save' },
            { '<leader>l', group = 'Activate' },
            { '<leader>g', group = 'Git' },
            { '<leader>gt', group = 'Toggle' },
            { '<leader>H', group = 'Keymaps' },
            { 'g', group = 'Go-to' },
            { '=', group = 'Filter paste' },
            { "<leader>w", proxy = "<c-w>", group = "windows" },
            { "<leader>b", group = "buffers", expand = function()
                    return require("which-key.extras").expand.buf()
                end
            },

            {
                -- Nested mappings are allowed and can be added in any order
                -- Most attributes can be inherited or overridden on any level
                -- There's no limit to the depth of nesting
                -- mode = { "n", "v" }, -- NORMAL and VISUAL mode
                -- { "<leader>Q", "<cmd>q<cr>", desc = "Quit" }, -- no need to specify mode since it's inherited
                -- { "<leader>W", "<cmd>w<cr>", desc = "Write" },
            }

        }


    end
}

