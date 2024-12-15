return {
    {
        "tpope/vim-fugitive",
        dependencies = {
            "tpope/vim-rhubarb",
            "shumphrey/fugitive-gitlab.vim",
        },
    },
    {
        "lewis6991/gitsigns.nvim",
        cond = true,
        config = function()
            require("gitsigns").setup({
                signs = {
                    add = { text = "┃" },
                    change = { text = "┃" },
                    delete = { text = "_" },
                    topdelete = { text = "‾" },
                    changedelete = { text = "~" },
                    untracked = { text = "┆" },
                },
                numhl = false,     -- Toggle with `:Gitsigns toggle_numhl`
                linehl = false,    -- Toggle with `:Gitsigns toggle_linehl`
                word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
                watch_gitdir = {
                    follow_files = true,
                },
                auto_attach = true,
                attach_to_untracked = false,
                current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
                current_line_blame_opts = {
                    virt_text = true,
                    virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
                    delay = 1000,
                    ignore_whitespace = false,
                    virt_text_priority = 100,
                },
                current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
                sign_priority = 6,
                update_debounce = 100,
                status_formatter = nil,  -- Use default
                max_file_length = 40000, -- Disable if file is longer than this (in lines)
                preview_config = {
                    -- Options passed to nvim_open_win
                    border = "single",
                    style = "minimal",
                    relative = "cursor",
                    row = 0,
                    col = 1,
                },
                on_attach = function(bufnr)
                    local gitsigns = require("gitsigns")

                    local function map(mode, l, r, opts)
                        opts = opts or {}
                        opts.buffer = bufnr
                        vim.keymap.set(mode, l, r, opts)
                    end

                    -- Navigation
                    map("n", "]c", function()
                        if vim.wo.diff then
                            vim.cmd.normal({ "]c", bang = true })
                        else
                            gitsigns.nav_hunk("next")
                        end
                    end)

                    map("n", "[c", function()
                        if vim.wo.diff then
                            vim.cmd.normal({ "[c", bang = true })
                        else
                            gitsigns.nav_hunk("prev")
                        end
                    end)

                    -- Actions
                    map("n", "<leader>hs", gitsigns.stage_hunk, { desc = "stage hunk" })
                    map("n", "<leader>hr", gitsigns.reset_hunk, { desc = "reset hunk" })
                    map("v", "<leader>hs", function()
                        gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
                    end, { desc = "stage hunk" })
                    map("v", "<leader>hr", function()
                        gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
                    end, { desc = "reset hunk" })
                    map("n", "<leader>hS", gitsigns.stage_buffer, { desc = "stage buffer" })
                    map("n", "<leader>hu", gitsigns.undo_stage_hunk, { desc = "undo staged hunk" })
                    map("n", "<leader>hR", gitsigns.reset_buffer, { desc = "reset hunk" })
                    map("n", "<leader>hp", gitsigns.preview_hunk, { desc = "preview hunk" })
                    map("n", "<leader>hb", function()
                        gitsigns.blame_line({ full = true })
                    end, { desc = "show blame" })
                    map("n", "<leader>htb", gitsigns.toggle_current_line_blame, { desc = "toggle current line blame" })
                    map("n", "<leader>hd", gitsigns.diffthis, { desc = "diff this" })
                    map("n", "<leader>hD", function()
                        gitsigns.diffthis("~")
                    end, { desc = "diff to origin" })
                    map("n", "<leader>htd", gitsigns.toggle_deleted, { desc = "toggle deleted" })

                    -- Text object
                    map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "select hunk" })
                end,
            })
        end,
    },
    {
        "NeogitOrg/neogit",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "sindrets/diffview.nvim",
            "ibhagwan/fzf-lua",
        },
        config = function()
            local neogit = require("neogit")

            neogit.setup({
                -- Hides the hints at the top of the status buffer
                disable_hint = false,
                -- Disables changing the buffer highlights based on where the cursor is.
                disable_context_highlighting = true,
                -- Disables signs for sections/items/hunks
                disable_signs = false,
                -- Changes what mode the Commit Editor starts in. `true` will leave nvim in normal mode, `false` will change nvim to
                -- insert mode, and `"auto"` will change nvim to insert mode IF the commit message is empty, otherwise leaving it in
                -- normal mode.
                disable_insert_on_commit = "auto",
                -- When enabled, will watch the `.git/` directory for changes and refresh the status buffer in response to filesystem
                -- events.
                filewatcher = {
                    interval = 1000,
                    enabled = true,
                },
                -- "ascii"   is the graph the git CLI generates
                -- "unicode" is the graph like https://github.com/rbong/vim-flog
                graph_style = "unicode",
                -- Used to generate URL's for branch popup action "pull request".
                git_services = {
                    ["github.com"] = "https://github.com/${owner}/${repository}/compare/${branch_name}?expand=1",
                    ["bitbucket.org"] =
                    "https://bitbucket.org/${owner}/${repository}/pull-requests/new?source=${branch_name}&t=1",
                    ["gitlab.com"] =
                    "https://gitlab.com/${owner}/${repository}/merge_requests/new?merge_request[source_branch]=${branch_name}",
                },
                -- Allows a different telescope sorter. Defaults to 'fuzzy_with_index_bias'. The example below will use the native fzf
                -- sorter instead. By default, this function returns `nil`.
                telescope_sorter = function()
                    return require("telescope").extensions.fzf.native_fzf_sorter()
                end,
                -- Persist the values of switches/options within and across sessions
                remember_settings = true,
                -- Scope persisted settings on a per-project basis
                use_per_project_settings = true,
                -- Table of settings to never persist. Uses format "Filetype--cli-value"
                ignored_settings = {
                    "NeogitPushPopup--force-with-lease",
                    "NeogitPushPopup--force",
                    "NeogitPullPopup--rebase",
                    "NeogitCommitPopup--allow-empty",
                    "NeogitRevertPopup--no-edit",
                },
                -- Configure highlight group features
                highlight = {
                    italic = true,
                    bold = true,
                    underline = true,
                },
                -- Set to false if you want to be responsible for creating _ALL_ keymappings
                use_default_keymaps = true,
                -- Neogit refreshes its internal state after specific events, which can be expensive depending on the repository size.
                -- Disabling `auto_refresh` will make it so you have to manually refresh the status after you open it.
                auto_refresh = true,
                -- Value used for `--sort` option for `git branch` command
                -- By default, branches will be sorted by commit date descending
                -- Flag description: https://git-scm.com/docs/git-branch#Documentation/git-branch.txt---sortltkeygt
                -- Sorting keys: https://git-scm.com/docs/git-for-each-ref#_options
                sort_branches = "-committerdate",
                -- Change the default way of opening neogit
                kind = "tab",
                -- Disable line numbers and relative line numbers
                disable_line_numbers = false,
                -- The time after which an output console is shown for slow running commands
                console_timeout = 2000,
                -- Automatically show console if a command takes more than console_timeout milliseconds
                auto_show_console = true,
                status = {
                    show_head_commit_hash = true,
                    recent_commit_count = 10,
                    HEAD_padding = 10,
                    mode_padding = 3,
                    mode_text = {
                        M = "modified",
                        N = "new file",
                        A = "added",
                        D = "deleted",
                        C = "copied",
                        U = "updated",
                        R = "renamed",
                        DD = "unmerged",
                        AU = "unmerged",
                        UD = "unmerged",
                        UA = "unmerged",
                        DU = "unmerged",
                        AA = "unmerged",
                        UU = "unmerged",
                        ["?"] = "",
                    },
                },
                commit_editor = {
                    kind = "tab",
                    show_staged_diff = true,
                    -- Accepted values:
                    -- "split" to show the staged diff below the commit editor
                    -- "vsplit" to show it to the right
                    -- "split_above" Like :top split
                    -- "auto" "vsplit" if window would have 80 cols, otherwise "split"
                    staged_diff_split_kind = "auto",
                },
                commit_select_view = {
                    kind = "tab",
                },
                commit_view = {
                    kind = "vsplit",
                    verify_commit = vim.fn.executable("gpg") == 1, -- Can be set to true or false, otherwise we try to find the binary
                },
                log_view = {
                    kind = "tab",
                },
                rebase_editor = {
                    kind = "tab",
                },
                reflog_view = {
                    kind = "tab",
                },
                merge_editor = {
                    kind = "tab",
                },
                tag_editor = {
                    kind = "tab",
                },
                preview_buffer = {
                    kind = "split",
                },
                popup = {
                    kind = "split",
                },
                signs = {
                    -- { CLOSED, OPENED }
                    hunk = { "", "" },
                    item = { ">", "v" },
                    section = { ">", "v" },
                },
                -- Each Integration is auto-detected through plugin presence, however, it can be disabled by setting to `false`
                integrations = {
                    -- If enabled, use telescope for menu selection rather than vim.ui.select.
                    -- Allows multi-select and some things that vim.ui.select doesn't.
                    telescope = false,
                    -- Neogit only provides inline diffs. If you want a more traditional way to look at diffs, you can use `diffview`.
                    -- The diffview integration enables the diff popup.
                    --
                    -- Requires you to have `sindrets/diffview.nvim` installed.
                    diffview = true,

                    -- If enabled, uses fzf-lua for menu selection. If the telescope integration
                    -- is also selected then telescope is used instead
                    -- Requires you to have `ibhagwan/fzf-lua` installed.
                    fzf_lua = true,
                },
                sections = {
                    -- Reverting/Cherry Picking
                    sequencer = {
                        folded = false,
                        hidden = false,
                    },
                    untracked = {
                        folded = false,
                        hidden = false,
                    },
                    unstaged = {
                        folded = false,
                        hidden = false,
                    },
                    staged = {
                        folded = false,
                        hidden = false,
                    },
                    stashes = {
                        folded = true,
                        hidden = false,
                    },
                    unpulled_upstream = {
                        folded = true,
                        hidden = false,
                    },
                    unmerged_upstream = {
                        folded = false,
                        hidden = false,
                    },
                    unpulled_pushRemote = {
                        folded = true,
                        hidden = false,
                    },
                    unmerged_pushRemote = {
                        folded = false,
                        hidden = false,
                    },
                    recent = {
                        folded = true,
                        hidden = false,
                    },
                    rebase = {
                        folded = true,
                        hidden = false,
                    },
                },
                mappings = {
                    commit_editor = {
                        ["q"] = "Close",
                        ["<c-c><c-c>"] = "Submit",
                        ["<c-c><c-k>"] = "Abort",
                    },
                    commit_editor_I = {
                        ["<c-c><c-c>"] = "Submit",
                        ["<c-c><c-k>"] = "Abort",
                    },
                    rebase_editor = {
                        ["p"] = "Pick",
                        ["r"] = "Reword",
                        ["e"] = "Edit",
                        ["s"] = "Squash",
                        ["f"] = "Fixup",
                        ["x"] = "Execute",
                        ["d"] = "Drop",
                        ["b"] = "Break",
                        ["q"] = "Close",
                        ["<cr>"] = "OpenCommit",
                        ["gk"] = "MoveUp",
                        ["gj"] = "MoveDown",
                        ["<c-c><c-c>"] = "Submit",
                        ["<c-c><c-k>"] = "Abort",
                        ["[c"] = "OpenOrScrollUp",
                        ["]c"] = "OpenOrScrollDown",
                    },
                    rebase_editor_I = {
                        ["<c-c><c-c>"] = "Submit",
                        ["<c-c><c-k>"] = "Abort",
                    },
                    finder = {
                        ["<cr>"] = "Select",
                        ["<c-c>"] = "Close",
                        ["<esc>"] = "Close",
                        ["<c-n>"] = "Next",
                        ["<c-p>"] = "Previous",
                        ["<down>"] = "Next",
                        ["<up>"] = "Previous",
                        ["<tab>"] = "MultiselectToggleNext",
                        ["<s-tab>"] = "MultiselectTogglePrevious",
                        ["<c-j>"] = "NOP",
                    },
                    -- Setting any of these to `false` will disable the mapping.
                    popup = {
                        ["?"] = "HelpPopup",
                        ["A"] = "CherryPickPopup",
                        ["D"] = "DiffPopup",
                        ["M"] = "RemotePopup",
                        ["P"] = "PushPopup",
                        ["X"] = "ResetPopup",
                        ["Z"] = "StashPopup",
                        ["b"] = "BranchPopup",
                        ["B"] = "BisectPopup",
                        ["c"] = "CommitPopup",
                        ["f"] = "FetchPopup",
                        ["l"] = "LogPopup",
                        ["m"] = "MergePopup",
                        ["p"] = "PullPopup",
                        ["r"] = "RebasePopup",
                        ["v"] = "RevertPopup",
                        ["w"] = "WorktreePopup",
                    },
                    status = {
                        ["q"] = "Close",
                        ["I"] = "InitRepo",
                        ["1"] = "Depth1",
                        ["2"] = "Depth2",
                        ["3"] = "Depth3",
                        ["4"] = "Depth4",
                        ["<tab>"] = "Toggle",
                        ["x"] = "Discard",
                        ["s"] = "Stage",
                        ["S"] = "StageUnstaged",
                        ["<c-s>"] = "StageAll",
                        ["K"] = "Untrack",
                        ["u"] = "Unstage",
                        ["U"] = "UnstageStaged",
                        ["$"] = "CommandHistory",
                        -- ["#"] = "Console",
                        ["Y"] = "YankSelected",
                        ["<c-r>"] = "RefreshBuffer",
                        ["<enter>"] = "GoToFile",
                        ["<c-v>"] = "VSplitOpen",
                        ["<c-x>"] = "SplitOpen",
                        ["<c-t>"] = "TabOpen",
                        ["{"] = "GoToPreviousHunkHeader",
                        ["}"] = "GoToNextHunkHeader",
                        ["[c"] = "OpenOrScrollUp",
                        ["]c"] = "OpenOrScrollDown",
                    },
                    intergrations = {
                        telescope = true,
                        diffview = true,
                    },
                },
            })
        end,
    },
    {
        "rbong/vim-flog",
        lazy = true,
        cmd = { "Flog", "Flogsplit", "Floggit" },
        dependencies = {
            "tpope/vim-fugitive",
        },
    },
    {
        "rmagatti/igs.nvim",
        cond = true,
        config = function()
            require("igs").setup({
                default_mappings = true,
            })
        end,
    },
    {
        "ruifm/gitlinker.nvim",
        config = function()
            require('gitlinker').setup()

            vim.keymap.set('n', '<leader>go',
                '<cmd>lua require"gitlinker".get_buf_range_url("n", {action_callback = require"gitlinker.actions".open_in_browser})<cr>',
                { desc = "Open Permalink in Browser", silent = true })
            vim.keymap.set('v', '<leader>go',
                '<cmd>lua require"gitlinker".get_buf_range_url("v", {action_callback = require"gitlinker.actions".open_in_browser})<cr>',
                { desc = "Open Permalink in Browser" })
        end,
    },
    {
        "tanvirtin/vgit.nvim",
        config = function()
            require("vgit").setup({
                keymaps = {
                    ["n <leader>gP"] = function()
                        require("vgit").hunk_up()
                    end,
                    ["n <leader>gN"] = function()
                        require("vgit").hunk_down()
                    end,
                    ["n <leader>gs"] = function()
                        require("vgit").buffer_hunk_stage()
                    end,
                    ["n <leader>gr"] = function()
                        require("vgit").buffer_hunk_reset()
                    end,
                    ["n <leader>gp"] = function()
                        require("vgit").buffer_hunk_preview()
                    end,
                    ["n <leader>gb"] = function()
                        require("vgit").buffer_blame_preview()
                    end,
                    ["n <leader>gf"] = function()
                        require("vgit").buffer_diff_preview()
                    end,
                    ["n <leader>gH"] = function()
                        require("vgit").buffer_history_preview()
                    end,
                    ["n <leader>gu"] = function()
                        require("vgit").buffer_reset()
                    end,
                    ["n <leader>ghu"] = function()
                        require("vgit").buffer_hunks_preview()
                    end,
                    ["n <leader>ghs"] = function()
                        require("vgit").project_hunks_staged_preview()
                    end,
                    ["n <leader>gd"] = function()
                        require("vgit").project_diff_preview()
                    end,
                    ["n <leader>gx"] = function()
                        require("vgit").toggle_diff_preference()
                    end,
                },
                settings = {
                    git = {
                        cmd = "git", -- optional setting, not really required
                        fallback_cwd = vim.fn.expand("$HOME"),
                        fallback_args = {
                            "--git-dir",
                            vim.fn.expand("$HOME/dots/yadm-repo"),
                            "--work-tree",
                            vim.fn.expand("$HOME"),
                        },
                    },
                    hls = {
                        GitBackground = "Normal",
                        GitHeader = "NormalFloat",
                        GitFooter = "NormalFloat",
                        GitBorder = "LineNr",
                        GitLineNr = "LineNr",
                        GitComment = "Comment",
                        GitSignsAdd = {
                            gui = nil,
                            fg = "#d7ffaf",
                            bg = nil,
                            sp = nil,
                            override = false,
                        },
                        GitSignsChange = {
                            gui = nil,
                            fg = "#7AA6DA",
                            bg = nil,
                            sp = nil,
                            override = false,
                        },
                        GitSignsDelete = {
                            gui = nil,
                            fg = "#e95678",
                            bg = nil,
                            sp = nil,
                            override = false,
                        },
                        GitSignsAddLn = "DiffAdd",
                        GitSignsDeleteLn = "DiffDelete",
                        GitWordAdd = {
                            gui = nil,
                            fg = nil,
                            bg = "#5d7a22",
                            sp = nil,
                            override = false,
                        },
                        GitWordDelete = {
                            gui = nil,
                            fg = nil,
                            bg = "#960f3d",
                            sp = nil,
                            override = false,
                        },
                    },
                    live_blame = {
                        enabled = true,
                        format = function(blame, git_config)
                            local config_author = git_config["user.name"]
                            local author = blame.author
                            if config_author == author then
                                author = "You"
                            end
                            local time = os.difftime(os.time(), blame.author_time) / (60 * 60 * 24 * 30 * 12)
                            local time_divisions = {
                                { 1,  "years" },
                                { 12, "months" },
                                { 30, "days" },
                                { 24, "hours" },
                                { 60, "minutes" },
                                { 60, "seconds" },
                            }
                            local counter = 1
                            local time_division = time_divisions[counter]
                            local time_boundary = time_division[1]
                            local time_postfix = time_division[2]
                            while time < 1 and counter ~= #time_divisions do
                                time_division = time_divisions[counter]
                                time_boundary = time_division[1]
                                time_postfix = time_division[2]
                                time = time * time_boundary
                                counter = counter + 1
                            end
                            local commit_message = blame.commit_message
                            if not blame.committed then
                                author = "You"
                                commit_message = "Uncommitted changes"
                                return string.format(" %s • %s", author, commit_message)
                            end
                            local max_commit_message_length = 255
                            if #commit_message > max_commit_message_length then
                                commit_message = commit_message:sub(1, max_commit_message_length) .. "..."
                            end
                            return string.format(
                                " %s, %s • %s",
                                author,
                                string.format(
                                    "%s %s ago",
                                    time >= 0 and math.floor(time + 0.5) or math.ceil(time - 0.5),
                                    time_postfix
                                ),
                                commit_message
                            )
                        end,
                    },
                    live_gutter = {
                        enabled = true,
                        edge_navigation = true, -- This allows users to navigate within a hunk
                    },
                    authorship_code_lens = {
                        enabled = true,
                    },
                    scene = {
                        diff_preference = "unified", -- unified or split
                        keymaps = {
                            quit = "q",
                        },
                    },
                    diff_preview = {
                        keymaps = {
                            buffer_stage = "S",
                            buffer_unstage = "U",
                            buffer_hunk_stage = "s",
                            buffer_hunk_unstage = "u",
                            toggle_view = "t",
                        },
                    },
                    project_diff_preview = {
                        keymaps = {
                            buffer_stage = "s",
                            buffer_unstage = "u",
                            buffer_hunk_stage = "gs",
                            buffer_hunk_unstage = "gu",
                            buffer_reset = "r",
                            stage_all = "S",
                            unstage_all = "U",
                            reset_all = "R",
                        },
                    },
                    project_commit_preview = {
                        keymaps = {
                            save = "S",
                        },
                    },
                    signs = {
                        priority = 10,
                        definitions = {
                            GitSignsAddLn = {
                                linehl = "GitSignsAddLn",
                                texthl = nil,
                                numhl = nil,
                                icon = nil,
                                text = "",
                            },
                            GitSignsDeleteLn = {
                                linehl = "GitSignsDeleteLn",
                                texthl = nil,
                                numhl = nil,
                                icon = nil,
                                text = "",
                            },
                            GitSignsAdd = {
                                texthl = "GitSignsAdd",
                                numhl = nil,
                                icon = nil,
                                linehl = nil,
                                text = "┃",
                            },
                            GitSignsDelete = {
                                texthl = "GitSignsDelete",
                                numhl = nil,
                                icon = nil,
                                linehl = nil,
                                text = "┃",
                            },
                            GitSignsChange = {
                                texthl = "GitSignsChange",
                                numhl = nil,
                                icon = nil,
                                linehl = nil,
                                text = "┃",
                            },
                        },
                        usage = {
                            screen = {
                                add = "GitSignsAddLn",
                                remove = "GitSignsDeleteLn",
                            },
                            main = {
                                add = "GitSignsAdd",
                                remove = "GitSignsDelete",
                                change = "GitSignsChange",
                            },
                        },
                    },
                    symbols = {
                        void = "⣿",
                    },
                },
            })
        end,
    },
    {
        "kdheepak/lazygit.nvim",
        lazy = false,
        cmd = {
            "LazyGit",
            "LazyGitConfig",
            "LazyGitCurrentFile",
            "LazyGitFilter",
            "LazyGitFilterCurrentFile",
        },
        keys = {
            { "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
        },
        init = function()
            vim.g.lazygit_floating_window_winblend = 0
            vim.g.lazygit_floating_window_scaling_factor = 0.9
            vim.g.lazygit_floating_window_use_plenary = 1
        end,
    },
}
