return {
    {
        "prochri/telescope-all-recent.nvim",
        config = function()
            ---@diagnostic disable-next-line: missing-fields
            require("telescope-all-recent").setup({})
        end,
    },
    {
        "princejoogie/dir-telescope.nvim",
        config = function()
            require("dir-telescope").setup({
                hidden = true,
                no_ignore = false,
                show_preview = true,
                follow_symlinks = false,
            })
        end,
    },
    {
        "adoyle-h/ad-telescope-extensions.nvim",
        dependencies = {
            "adoyle-h/telescope-extension-maker.nvim",
        },
        config = function()
            require("ad-telescope-extensions").setup({
                enable = {
                    "changes",
                    "colors",
                    "env",
                    "floaterm",
                    "lsp_document_symbols_filter",
                    "lsp_dynamic_workspace_symbols_filter",
                    "lsp_workspace_symbols_filter",
                    "message",
                    "packpath",
                    "rtp",
                    "scriptnames",
                    "time",
                    "zk",
                },
            })
        end,
    },
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.7",
        dependencies = {
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                build = "make",
            },
            "johmsalas/text-case.nvim",
            "vuki656/package-info.nvim",
            "catgoose/telescope-helpgrep.nvim",
            "polirritmico/telescope-lazy-plugins.nvim",
            "scottmckendry/telescope-resession.nvim",
            "natecraddock/workspaces.nvim",
            "nvim-telescope/telescope-symbols.nvim",
            "mollerhoj/telescope-recent-files.nvim",
            "nvim-telescope/telescope-project.nvim",
            "nvim-telescope/telescope-file-browser.nvim",
            "debugloop/telescope-undo.nvim",
            "octarect/telescope-menu.nvim",
            "jonarrien/telescope-cmdline.nvim",
            "jvgrootveld/telescope-zoxide",
            "tsakirist/telescope-lazy.nvim",
            "fdschmidt93/telescope-egrepify.nvim",
            -- "tiagovla/scope.nvim",
            "LinArcX/telescope-env.nvim",
            "zane-/cder.nvim",
            "brookhong/telescope-pathogen.nvim",
            "nvim-telescope/telescope-github.nvim",
            "nvim-telescope/telescope-symbols.nvim",
            "cljoly/telescope-repo.nvim",
            "nvim-telescope/telescope-node-modules.nvim",
            "crispgm/telescope-heading.nvim",
            "xiyaowong/telescope-emoji.nvim",
            "sshelll/telescope-switch.nvim",
            "LinArcX/telescope-scriptnames.nvim",
            "lpoto/telescope-docker.nvim",
            "lpoto/telescope-tasks.nvim",
            "OliverChao/telescope-picker-list.nvim",
        },
        keys = {},
        config = function()
            -- configuration
            require("plugins.telescope.config")

            -- Keymaps
            local function opts(desc)
                return {
                    desc = "" .. desc,
                    noremap = true,
                    silent = true,
                    nowait = true,
                }
            end
            local builtin = require("telescope.builtin")
            local map = vim.keymap.set

            map("n", "<leader>/", function()
                -- You can pass additional configuration to telescope to change theme, layout, etc.
                require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
                    theme = "ivy",
                    winblend = 10,
                    previewer = false,
                }))
            end, {
                desc = "[/] Fuzzily search in current buffer]",
            })

            map("n", "<leader>fw", require("telescope.builtin").grep_string, {
                desc = "[S]earch current [W]ord",
            })

            map("n", "<leader>sd", require("telescope.builtin").diagnostics, {
                desc = "[S]earch [D]iagnostics",
            })

            map("n", "<leader>gS", require("telescope.builtin").git_status, {
                desc = "[S]earch Git [S]tatus",
            })

            map("n", "<Leader>sn", "<CMD>lua require('telescope').extensions.notify.notify()<CR>", {
                desc = "[S]earch [N]otify",
                silent = true,
            })

            map("n", "<Leader><tab>", "<Cmd>lua require('telescope.builtin').commands()<CR>", {
                desc = "Search [C]ommands",
                noremap = false,
            })

            map("n", "<leader>ff", function()
                require("telescope.builtin").find_files({
                    previewer = true,
                })
            end)
            map("n", "<leader>fg", "<cmd>Telescope egrepify<cr>", opts("Live Grep"))
            map("n", "<leader>fh", function()
                require("telescope.builtin").help_tags({})
            end)
            map("n", "<leader>ft", function()
                require("telescope.builtin").tags({})
            end)
            map("n", "<leader><leader>", function()
                require("telescope.builtin").oldfiles({})
            end)
            map("n", "<leader>fb", function()
                require("telescope.builtin").buffers({
                    sort_lastused = true,
                })
            end)
            -- TODO: commander
            -- require("commander").setup({
            -- 	integration = {
            -- 		lazy = {
            -- 			enable = false,
            -- 			set_plugin_name_as_cat = true,
            -- 		},
            -- 		telescope = {
            -- 			enable = true,
            -- 			theme = require("telescope.themes").commander,
            -- 		},
            -- 	},
            -- })

            -- extensions
            require("plugins.telescope.extensions")
        end,
    },
    {
        "nvim-telescope/telescope-ui-select.nvim",
        config = function()
            require("telescope").setup({
                extensions = {
                    ["ui-select"] = { require("telescope.themes").get_dropdown({}) },
                },
            })
            require("telescope").load_extension("ui-select")
        end,
    },
    {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        config = function()
            require("telescope").load_extension("fzf")
        end,
    },
}
