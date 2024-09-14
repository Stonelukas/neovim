return  
{
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
    priority = 500,
	dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
      -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
      "saifulapm/neotree-file-nesting-config", 
      {
          's1n7ax/nvim-window-picker',
          version = '2.*',
          config = function()
              require 'window-picker'.setup({
                  filter_rules = {
                      include_current_win = false,
                      autoselect_one = true,
                      -- filter using buffer options
                      bo = {
                          -- if the file type is one of the following, the window will be ignored
                          filetype = { 'neotree', "neo-tree-popup", "notify" },
                          -- if the buffer type is one of the following, the window will be ignored
                          buftype = { 'terminal', "quickfix" }
                      },
                  },
              })
          end,
      },
    },
    opts = {},
    config = function(_, opts)
        -- If you want icons for diagnostic errors, you'll need to define them somewhere:
        vim.fn.sign_define("DiagnosticSignError",
            {text = " ", texthl = "DiagnosticSignError"})
        vim.fn.sign_define("DiagnosticSignWarn",
            {text = " ", texthl = "DiagnosticSignWarn"})
        vim.fn.sign_define("DiagnosticSignInfo",
            {text = " ", texthl = "DiagnosticSignInfo"})
        vim.fn.sign_define("DiagnosticSignHint",
            {text = "󰌵", texthl = "DiagnosticSignHint"})

        -- TODO Telescope
        -- function getTelescopeOpts(state, path)
        -- return {
        --     cwd = path,
        --     search_dirs = { path },
        --     attach_mappings = function (prompt_bufnr, map)
        --     local actions = require "telescope.actions"
        --     actions.select_default:replace(function()
        --         actions.close(prompt_bufnr)
        --         local action_state = require "telescope.actions.state"
        --         local selection = action_state.get_selected_entry()
        --         local filename = selection.filename
        --         if (filename == nil) then
        --         filename = selection[1]
        --         end
        --         -- any way to open the file without triggering auto-close event of neo-tree?
        --         require("neo-tree.sources.filesystem").navigate(state, state.path, filename)
        --     end)
        --     return true
        --     end
        -- }
        -- end

        local inputs = require 'neo-tree.ui.inputs' 

        --trash the target
        local function trash(state)
            local node = state.tree:get_node()
            if node.type == "message" then
                return
            end
            local _, name = require 'neo-tree.utils'.split_path(node.path)
            local msg = string.format("Are you sure you want to trash '%s'?", name)
            inputs.confirm(msg, function(confirmed)
                if not confirmed then 
                    return
                end 
                vim.api.nvim_command("silent !trash -f " .. node.path)
                require 'neo-tree.sources.manager'.refresh(state)
            end)
        end

        -- Trash the selections (visual mode)
        local function trash_visual(state, selected_nodes)
            local paths_to_trash = {}
            for _, node in ipairs(selected_nodes) do
                if node.type ~= "message" then
                    table.insert(paths_to_trash, node.path)
                end
            end
            local msg = "Are you sure you want to trash " .. #paths_to_trash .. "items?"
            inputs.confirm(msg, function(confirmed)
                if not confirmed then 
                    return
                end 
                for _, path in ipairs(paths_to_trash) do
                    vim.api.nvim_command("silent !trash -f " .. path)
                end
                require 'neo-tree.sources.manager'.refresh(state)
            end)
        end
            

        -- Nesting rules from "saifulapm/neotree-file-nesting-config"
        opts.nesting_rules = require 'neotree-file-nesting-config'.nesting_rules
        require 'neo-tree'.setup(opts)
        require 'neo-tree'.setup({
            hide_root_node = true,
            retain_hidden_root_indent = true,
            close_if_last_window = true, -- Close Neo-tree if it is the last window left in the tab
            popup_border_style = "rounded",
            enable_git_status = true,
            enable_diagnostics = true,
            open_files_do_not_replace_types = { "terminal", "trouble", "qf" }, -- when opening files, do not use windows containing these filetypes orf buftypes
            sort_case_insensitive = false,
            sort_function = nil,
            nesting_rules = {
                ["js"] = { "js.map" },
                ["package.json"] = {
                    pattern = "^package%.json$", -- <-- Lua pattern
                    files = { "package-lock.json", "yarn*" }, -- <-- glob pattern
                },
                ["go"] = {
                    pattern = "(.*)%.go$", -- <-- Lua pattern with capture
                    files = { "%1_test.go" }, -- <-- glob pattern with capture
                },
                ["js-extended"] = {
                    pattern = "(.+)%.js$",
                    files = { "%1.js.map", "%1.min.js", "%1.d.ts" },
                },
                ["docker"] = {
                    pattern = "^dockerfile$",
                    ignore_case = true,
                    files = { ".dockerignore", "docker-compose.*", "dockerfile*" },
                },
            },
            sources = {
                "filesystem", 
                "buffers",
                "git_status",
                "document_symbols",
                "netman.ui.neo-tree",
            },
            default_component_config = {
                container = {
                    enable_character_fade = true
                },
                indent = {
                    indent_size = 2,
                    padding = 1, -- extra padding on the left hand side
                    --indent guides 
                    with_markers = true,
                    indent_marker = "│",
                    last_indent_marker = "└",
                    highlight = "NeoTreeIndentMarker",
                    -- expander config, needed for nesting files
                    with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
                    expander_collapsed = "",
                    expander_expanded = " ",
                    expander_highlight = "NeoTreeExpander",
                },
                icon = {
                    folder_closed = "",
                    folder_open = "",
                    folder_empty = "󰜌",               
                    provider = function(icon, node, state) -- default icon provider utilizes nvim-web-devicons if available
                        if node.type == "file" or node.type == "terminal" then
                            local success, web_devicons = pcall(require, "nvim-web-devicons")
                            local name = node.type == "terminal" and "terminal" or node.name
                            if success then
                                local devicon, hl = web_devicons.get_icon(name)
                                icon.text = devicon or icon.text
                                icon.highlight = hl or icon.highlight
                            end
                        end
                    end,
                },
                modified = {
                    symbol = "[+]",
                    highlight = "NeoTreeModified",
                },
                name = {
                    trailing_slash = false,
                    use_git_status_colors = true,
                    highlight = "NeoTreeFileName",
                },
                git_status = {
                    window = {
                        position = "float",
                        mappings = {
                            ["A"]  = "git_add_all",
                            ["gu"] = "git_unstage_file",
                            ["ga"] = "git_add_file",
                            ["gr"] = "git_revert_file",
                            ["gc"] = "git_commit",
                            ["gp"] = "git_push",
                            ["gg"] = "git_commit_and_push",
                            ["o"] = { "show_help", nowait=false, config = { title = "Order by", prefix_key = "o" }},
                            ["oc"] = { "order_by_created", nowait = false },
                            ["od"] = { "order_by_diagnostics", nowait = false },
                            ["om"] = { "order_by_modified", nowait = false },
                            ["on"] = { "order_by_name", nowait = false },
                            ["os"] = { "order_by_size", nowait = false },
                            ["ot"] = { "order_by_type", nowait = false },
                        }
                    },
                    symbols = {
                        -- Change type
                        added = "✚",
                        deleted = "✖",
                        modified = "",
                        renamed = "󰁕",
                        -- Status type
                        untracked = "",
                        ignored = "",
                        unstaged = "󰄱",
                        staged = "",
                        conflict = "",
                    },
                },
                -- If you don't want to use these columns, you can set `enabled = false` for each of them individually
                file_size = {
                    enabled = true,
                    required_width = 200, -- min width of window required to show this column
                },
                type = {
                    enabled = true,
                    required_width = 122, -- min width of window required to show this column
                },
                last_modified = {
                    enabled = true,
                    required_width = 88, -- min width of window required to show this column
                },
                created = {
                    enabled = true,
                    required_width = 110, -- min width of window required to show this column
                },
                symlink_target = {
                    enabled = false,
                },
                diagnostics = {
                    symbols = {
                        hint = "H",
                        info = "I",
                        warn = "!",
                        error = "X",
                    },
                    highlights = {
                        hint = "DiagnosticSignHint",
                        info = "DiagnosticSignInfo",
                        warn = "DiagnosticSignWarn",
                        error = "DiagnosticSignError",
                    },
                },
            },
            commands = {
                system_open = function(state)
                    local node = state.tree:get_node()
                    local path = node:get_id()
                    vim.fn.jobstart({ "xdg-open", path }, { detach = true})
                end,
                run_command = function(state)
                    local node = state.tree:get_node()
                    local path = node:get_id()
                    vim.api.nvim_input(": " .. path .. "<Home>")
                end,
                trash = trash,
                trash_visual = trash_visual,
                -- TODO Telescope
                -- telescope_find = function(state)
                --     local node = state.tree:get_node()
                --     local path = node:get_id()
                --     require 'telescope.builtin'.find_files(getTelescopeOpts(state, path))
                -- end,
                -- telescope_grep = function(state)
                --     local node = state.tree:get_node()
                --     local path = node:get_id()
                --     require 'telescope.builtin'.live_grep(getTelescopeOpts(state, path))
                -- end,
            },
            window = {
                position = "left",
                width = 50,
                mapping_options = {
                    noremap = true,
                    nowait = true,
                },
                popup = {
                    position = { col = "50%", row = "8" },
                    size = function(state)
                        local root_name = vim.fn.fnamemodify(state.path, ":~")
                        local root_len = string.len(root_name) + 4
                        return {
                            width = math.max(root_len, 100 ),
                            height = vim.o.lines - 18,
                        }
                    end,
                },
                mappings = {
                    ["e"] = function()
                        vim.api.nvim_exec2("Neotree focus filesystem left", {})
                    end,
                    ["b"] = function()
                        vim.api.nvim_exec2("Neotree focus buffers left", {})
                    end,
                    ["g"] = function()
                        vim.api.nvim_exec2("Neotree close", {})
                        vim.api.nvim_exec2("Neotree reveal git_status float", {})
                    end,
                    ["r"] = function()
                        vim.api.nvim_exec2("Neotree focus remote left", {})
                    end,
                    ["s"] = function()
                        vim.api.nvim_exec2("Neotree focus document_symbols left", {})
                    end,
                    ["o"] = "system_open",
                    ["c"] = "run_command",
                    ["d"] = "trash",
                    ["<tab>"] = function(state)
                        local node = state.tree:get_node()
                        if require 'neo-tree.utils'.is_expandable(node) then
                            state.commands["toggle_node"](state)
                        else
                            state.commands['open'](state)
                            vim.cmd('Neotree last')
                        end
                    end,
                    ["h"] = function(state)
                        local node = state.tree:get_node()
                        if node.type == 'directory' and node:is_expanded() then
                            require 'neo-tree.sources.filesystem'.toggle_directory(state, node)
                        else
                            require 'neo-tree.ui.renderer'.focus_node(state, node:get_parent_id())
                        end
                    end,
                    ["l"] = function(state)
                        local node = state.tree:get_node()
                        if node.type == 'directory' and node:is_expanded() then
                            require 'neo-tree.sources.filesystem'.toggle_directory(state, node)
                        else
                            require 'neo-tree.ui.renderer'.focus_node(state, node:get_child_ids()[1])
                        end
                    end,
                    -- TODO Telescope
                    -- ["tf"] = "telescope_find",
                    -- ["tg"] = "telescope_grep",
                },
            },
            filesystem = {
                window = {
                    mappings = {
                        ["<F5>"] = "refresh",
                    },
                },
                filtered_items = {
                    visible = true,
                    show_hidden_count = false,
                    hide_dotfiles = true,
                    hide_gitignored = true,
                    hide_hidden = true, -- only works on Windows for hidden files/directories
                    hide_by_name = {},
                    hide_by_pattern = {},
                    always_show = {},
                    never_show = {
                        '.DS_Store',
                    },
                    never_show_by_pattern = {},
                },
                follow_current_file = {
                    enabled = true, 
                    leave_dirs_open = true
                },
                group_empty_dirs = true,
                hijack_netrw_behaviour = "open_current",
                use_libuv_file_watcher = true
            },
            buffers = {
                follow_current_file = {
                    enabled = true, 
                    leave_dirs_open = true
                },
                group_empty_dirs = true,
                show_unloaded = true
            },
            source_selector = {
                winbar = true,
                statusline = false,
                show_scrolled_off_parent_node = true,
                sources = {
                    {
                        source = "filesystem", -- string
                        display_name = " 󰉓 Files ", -- string | nil
                    },
                    {
                        source = "buffers", -- string
                        display_name = " 󰈚 Buffers ", -- string | nil
                    },
                    {
                        source = "git_status", -- string
                        display_name = " 󰊢 Git ", -- string | nil
                    },
                    {
                        source = "remote", 
                        display_name = " Remote",
                    },
                    {
                        source = "document_symbols",
                        display_name = "󰆧 Symbols",
                    },
                },
                content_layout = "start", -- string
                tabs_layout = "active", -- string
                truncation_character = "…", -- string
                tabs_min_width = nil, -- int | nil
                tabs_max_width = nil, -- int | nil
                padding = 2, -- int | { left: int, right: int }
                separator = { left = "▏", right = "▕" }, -- string | { left: string, right: string, override: string | nil }
                separator_active = nil, -- string | { left: string, right: string, override: string | nil } | nil
                show_separator_on_edge = false, -- boolean
                highlight_tab = "NeoTreeTabInactive", -- string
                highlight_tab_active = "NeoTreeTabActive", -- string
                highlight_background = "NeoTreeTabInactive", -- string
                highlight_separator = "NeoTreeTabSeparatorInactive", -- string
                highlight_separator_active = "NeoTreeTabSeparatorActive",
            },
            event_handlers = {
                {
                    event = "file_opened",
                    ---@diagnostic disable-next-line: unused-local
                    handler = function(file_path)
                        -- auto close
                        -- vimc.cmd("Neotree close")
                        -- OR
                        require("neo-tree.command").execute({ action = "close" })
                    end,
                },
                {
                    event = "neo_tree_window_after_open",
                    handler = function(args)
                        if args.position == "left" or args.position == "right" then
                            vim.cmd("wincmd =")
                        end
                    end
                },
                {
                    event = "neo_tree_window_after_close",
                    handler = function(args)
                        if args.position == "left" or args.position == "right" then
                            vim.cmd("wincmd =")
                        end
                    end
                },
                {
                    event = "neo_tree_buffer_enter",
                    handler = function()
                        vim.cmd 'highlight! Cursor blend=100'
                    end,
                },
                {
                    event = "neo_tree_buffer_leave",
                    handler = function()
                        vim.cmd 'highlight! Cursor guibg=#5f87af blend=0'
                    end,
                },
                {
                    event = "after_render",
                    handler = function(state)
                        if state.current_position == "left" or state.current_position == "right" then
                            vim.api.nvim_win_call(state.winid, function()
                                local str = require 'neo-tree.ui.selector'.get()
                                if str then
                                    _G.__cached_neo_tree_selector = str
                                end
                            end)
                        end
                    end,
                },
            },
        })


		vim.keymap.set("n", "<leader>ä", ":Neotree last <CR>", { noremap = true, silent = true })
        vim.keymap.set("n", "<leader>#", ":Neotree <CR>", { noremap = true, silent = true})
    end 
}
