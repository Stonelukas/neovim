-- Git
local Hydra = require('hydra')
local gitsigns = require('gitsigns')

local git_hint = [[
    _J_: next hunk  _s_: stage hunk         _d_: show deleted   _b_: blame line
    _K_: prev hunk  _u_: undo last stage     _p_: preview hunk   _B_: blame show full
    ^ ^             _S_: stage buffer       ^ ^                 _/_: show base file
    ^ 
    ^ ^             _<enter>_: Neogit               _q_: exit
]]


Hydra {
    name = 'Git',
    hint = git_hint,
    config = {
        buffer = bufnr,
        color = 'red',
        invoke_on_body = true,
        desc = 'Git',
        hint = {
            float_opts = {
                title = 'Git',
                border = 'rounded',
                style = 'minimal' 
            },
            show_name = true,
        },
        on_key = function() vim.wait(50) end,
        on_enter = function()
            vim.cmd 'mkview'
            vim.cmd 'silent! %foldopen!'
            vim.bo.modifiable = false
            gitsigns.toggle_signs(true)
            gitsigns.toggle_linehl(true)
        end,
        on_exit = function()
            local cursor_pos = vim.api.nvim_win_get_cursor(0)
            vim.cmd 'loadview'
            vim.api.nvim_win_set_cursor(0, cursor_pos)
            vim.cmd 'normal zv'
            -- gitsigns.toggle_signs(false)
            gitsigns.toggle_linehl(false)
            gitsigns.toggle_deleted(false)
        end,
    },
    mode = { 'n', 'x' },
    body = '<leader>gh',
    heads = {
        {
            'J', 
            function() 
                if vim.wo.diff then return ']c' end
                vim.schedule(function() gitsigns.next_hunk() end) 
                return '<Ignore>'
            end,
            { expr = true, desc = 'next hunk' } 
        },
        {
            'K', 
            function() 
                if vim.wo.diff then return '[c' end
                vim.schedule(function() gitsigns.prev_hunk() end) 
                return '<Ignore>'
            end,
            { expr = true, desc = 'prev hunk' } 
        },
        { 's', ':Gitsigns stage_hunk<cr>', { silent = true, desc = 'stage hunk' } },
        { 'u', gitsigns.undo_stage_hunk, { desc = 'undo last stage' } },
        { 'S', gitsigns.stage_buffer, { desc = 'stage buffer' } },
        { 'p', gitsigns.preview_hunk, { desc = 'preview hunk' } },
        { 'd', gitsigns.toggle_deleted, { nowait = true, desc = 'toggle deleted' } },
        { 'b', gitsigns.blame_line, { desc = 'blame' } },
        { 'B', function() gitsigns.blame_line { full = true } end, { desc = 'blame show full' } },
        { '/', gitsigns.show, { exit = true, desc = 'show base file' } },
        { '<enter>', '<cmd>Neogit<cr>', { exit = true, desc = 'Neogit' } },
        { 'q', nil, { exit = true, nowait = true, desc = 'exit' } },
    },
}

-- Side Scroll
Hydra {
   name = 'Side scroll',
   mode = 'n',
   body = 'z',
   heads = {
      { 'h', '5zh' },
      { 'l', '5zl', { desc = '←/→' } },
      { 'H', 'zH' },
      { 'L', 'zL', { desc = 'half screen ←/→' } },
   }
}


-- Telescope 
local cmd = require('hydra.keymap-util').cmd

local telescope_hint = [[
                 _f_: files       
   🭇🬭🬭🬭🬭🬭🬭🬭🬭🬼    _o_: old files   _g_: live grep
  🭉🭁🭠🭘    🭣🭕🭌🬾   _p_: projects    _/_: search in file
  🭅█ ▁     █🭐
  ██🬿      🭊██   _r_: resume      _u_: undotree
 🭋█🬝🮄🮄🮄🮄🮄🮄🮄🮄🬆█🭀  _h_: vim help    _c_: execute command
 🭤🭒🬺🬹🬱🬭🬭🬭🬭🬵🬹🬹🭝🭙  _k_: keymaps     _;_: commands history 
                 _O_: options     _?_: search history
 ^
                 _<Enter>_: Telescope           _q_
]]

Hydra {
    name = 'Telescope',
    hint = telescope_hint,
    config = {
        buffer = bufnr,
        color = 'teal',
        invoke_on_body = true,
        hint = {
            position = 'middle',
            float_opts = {
                border = 'rounded',
                title = 'Telescope',
                style = 'minimal',
            },
        },
    },
    mode = 'n',
    body = '<leader>ft',
    heads = {
        { 'f', cmd 'Telescope find_files' },
        { 'g', cmd 'Telescope live_grep' },
        { 'o', cmd 'Telescope oldfiles', { desc = 'recently opened files' } },
        { 'h', cmd 'Telescope help_tags', { desc = 'vim help' } },
        { 'k', cmd 'Telescope keymaps' },
        { 'O', cmd 'Telescope vim_options' },
        { 'r', cmd 'Telescope resume' },
        { 'p', cmd 'Telescope projects', { desc = 'projects' } },
        { '/', cmd 'Telescope current_buffer_fuzzy_find', { desc = 'search in file' } },
        { '?', cmd 'Telescope search_history',  { desc = 'search history' } },
        { ';', cmd 'Telescope command_history', { desc = 'command-line history' } },
        { 'c', cmd 'Telescope commands', { desc = 'execute command' } },
        { 'u', cmd 'silent! %foldopen! | UndotreeToggle', { desc = 'undotree' }},
        { '<Enter>', cmd 'Telescope', { exit = true, desc = 'list all pickers' } },
        { 'q', nil, { exit = true, nowait = true } },
    },
}


-- Vim Options
local options_hint = [[
    ^ ^         Options
    ^ 
    _v_ %{ve} virtual edit
    _i_ %{list} invisible characters
    _s_ %{spell} spell
    _w_ %{wrap} wrap
    _c_ %{cul} cursor line
    _n_ %{nu} number
    _r_ %{rnu} relative number
    ^
        ^^^^                    _q_
]]

Hydra {
    name = 'Options',
    hint = options_hint,
    config = {
        color = 'amaranth',
        invoke_on_body = true,
        hint = {
            position = 'middle',
            float_opts = {
                border = 'rounded',
            },
        },
    },
    mode = { 'n', 'x', },
    body = '<leader>o',
    heads = {
        { 'n', function()
            if vim.o.number == true then 
                vim.o.number = false
            else 
                vim.o.number = true
            end
        end, { desc = 'number' } },
        { 'r', function()
            if vim.o.relativenumber == true then 
                vim.o.relativenumber = false
            else 
                vim.o.relativenumber = true
            end
        end, { desc = 'relativenumber' } },
        { 'v', function()
            if vim.o.virtualedit == 'all' then 
                vim.o.virtualedit = 'block'
            else 
                vim.o.virtualedit = 'all'
            end
        end, { desc = 'virtualedit' } },
        { 'i', function()
            if vim.o.list == true then 
                vim.o.list = false
            else 
                vim.o.list = true
            end
        end, { desc = 'show invisible' } },
        { 's', function()
            if vim.o.spell == true then 
                vim.o.spell = false
            else 
                vim.o.spell = true
            end
        end, { exit = true, desc = 'spell' } },
        { 'w', function()
            if vim.o.wrap ~= true then 
                vim.o.wrap = true
                vim.keymap.set('n', 'k', function() return vim.v.count > 0 and 'k' or 'gk' end, { expr = true, desc = 'k or gk' })
                vim.keymap.set('n', 'j', function() return vim.v.count > 0 and 'j' or 'gj' end, { expr = true, desc = 'j or gj' })
            else 
                vim.o.wrap = false
                vim.keymap.del('n', 'k')
                vim.keymap.del('n', 'j')
            end
        end, { desc = 'wrap' } },
        { 'c', function()
            if vim.o.cursorline == true then 
                vim.o.cursorline = false
            else 
                vim.o.cursorline = true
            end
        end, { exit = true, desc = 'cursor line' } },
        { 'q' , nil, { exit = true } }
    },
}


        
 
