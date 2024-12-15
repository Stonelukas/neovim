return {
    "Acksld/nvim-neoclip.lua",
    priority = 900,
    config = function()
        local function is_whitespace(line)
            return vim.fn.match(line, [[^\s*$]]) ~= -1
        end

        local function all(tbl, check)
            for _, entry in ipairs(tbl) do
                if not check(entry) then
                    return false
                end
            end
            return true
        end

        require('neoclip').setup({
            history = 1000,
            continuous_sync = true,
            db_path = vim.fn.stdpath("data") .. "/databases/neoclip.sqlite3",
            preview = true,
            default_register = '+',
            default_register_macros = 'q',
            enable_macro_history = true,
            content_spec_column = false,
            disable_keycodes_parsing = false,
            on_select = {
                move_to_front = false,
                close_telescope = true,
            },
            on_paste = {
                set_reg = false,
                move_to_front = false,
                close_telescope = true,
            },
            on_replay = {
                set_reg = false,
                move_to_front = false,
                close_telescope = true,
            },
            on_custom_action = {
                close_telescope = true,
            },
            filter = function(data)
                return not all(data.event.regcontents, is_whitespace)
            end,
            keys = {
                telescope = {
                    i = {
                        select = '<cr>',
                        paste = '<c-p>',
                        paste_behind = '<c-k>',
                        replay = '<c-q>', -- replay a macro
                        delete = '<c-d>', -- delete an entry
                        edit = '<c-e>',   -- edit an entry
                        custom = {},
                    },
                    n = {
                        select = '<cr>',
                        paste = 'p',
                        --- It is possible to map to more than one key.
                        -- paste = { 'p', '<c-p>' },
                        paste_behind = 'P',
                        replay = 'q',
                        delete = 'd',
                        edit = 'e',
                        custom = {
                            ['<space>'] = function(opts)
                                print(vim.inspect(opts))
                            end,
                        },
                    },
                },
                fzf = {
                    select = 'default',
                    paste = 'ctrl-p',
                    paste_behind = 'ctrl-k',
                    custom = {},
                },
            },
        })
    end,
}
