local telescope = require("telescope")
local telescopeConfig = require("telescope.config")
local actions = require("telescope.actions")
local builtin = require('telescope.builtin')
local action_layout = require("telescope.actions.layout")
-- TODO: Trouble
-- local open_with_trouble = require 'trouble.sources.telescope'.open

-- clone the default Telescope configuration
local vimgrep_arguments = { unpack(telescopeConfig.values.vimgrep_arguments) }

-- I want to search in hidden/dotfiles
table.insert(vimgrep_arguments, "--hidden")
-- I don't want to search in the `.git` directory
table.insert(vimgrep_arguments, "--glob")
table.insert(vimgrep_arguments, "!**/.git/*")
table.insert(vimgrep_arguments, "--no-heading")
table.insert(vimgrep_arguments, "--line-number")
table.insert(vimgrep_arguments, "--column")
table.insert(vimgrep_arguments, "--trim")

telescope.setup({
	defaults = {
		vimgrep_arguments = vimgrep_arguments,
		dynamic_preview_title = true,
		preview = {
			treesitter = true,
		},
		set_env = { COLORTERM = "truecolor" },
		layout_config = {
			horizontal = {
				preview_width = function(_, cols, _)
					if cols > 200 then
						return math.floor(cols * 0.4)
					else
						return math.floor(cols * 0.6)
					end
				end,
			},
		},
		mappings = {
			i = {
				["<c-h>"] = "which_key",
				["<c-s>"] = actions.cycle_previewers_next,
				["<c-a>"] = actions.cycle_previewers_prev,
				["<c-g>"] = function(prompt_bufnr)
					-- use nvim-window-picker to choose the window by dynamically attaching a function
					local action_set = require("telescope.actions.set")
					local action_state = require("telescope.actions.state")

					local picker = action_state.get_current_picker(prompt_bufnr)
					picker.get_selection_window = function(picker, entry)
						local picked_window_id = require("window-picker").pick_window()
							or vim.api.nvim_get_current_win()
						picker.get_selection_window = nil
						return picked_window_id
					end

					return action_set.edit(prompt_bufnr, "edit")
				end,
			},
		},
	},
	pickers = {
		find_files = {
			find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
			mappings = {
				n = {
					["cd"] = function(prompt_bufnr)
						local selection = require("telescope.actions.state").get_selected_entry()
						local dir = vim.fn.fnamemodify(selection.path, ":p:h")
						require("telescope.actions").close(prompt_bufnr)
						vim.cmd(string.format("silent cd %s", dir))
					end,
				},
			},
			buffers = {
				show_all_buffers = true,
				sort_lastused = true,
			},
			mappings = {
				n = {
					["<leader>tp"] = action_layout.toggle_preview,
					-- TODO: Trouble
					-- ["<c-t>"] = open_with_trouble,
				},
				i = {
					["<A-p>"] = action_layout.toggle_preview,
				},
			},
		},
	},
	extensions = {
		repo = {
			list = {
				fd_opts = {
					"--no-ignore-vcs",
				},
				search_dirs = {
					"~/dotfiles",
					"~/github",
					"~/.local/share/nvim",
				},
			},
		},
		heading = {
			treesitter = true,
			picker_opts = {
				layout_config = { width = 0.8, preview_width = 0.5 },
				layout_strategy = "horizontal",
			},
		},
		switch = {
			matchers = {
				{
					name = "Plugin Config",
					from = "/lua/",
					search = "/lua/plugins",
				},
				{
					name = "Core Config",
					from = "/lua/",
					search = "/lua/core",
				},
			},
			picker = {
				seperator = "=> ",
				layout_strategy = "horizontal",
				layout_config = {
					width = 0.7,
					height = 0.6,
					preview_width = 0.6,
				},
				preview = true,
			},
		},
        undo = {
            use_delta = true,
            side_by_side = true,
            vim_diff_opts = {
                ctxlen = vim.o.scrolloff, 
            },
            layout_config = {
                preview_height = 0.8,
            },
        },
        docker = {
            theme = 'ivy',
            compose_binary = 'docker compose',
            buildx_binary = 'docker buildx',
            machine_binary = 'docker-machine',
            init_term = 'tabnew',
        },
        tasks = {
            theme = 'ivy',
            output = {
                style = 'float',
                layout = 'center',
                scale = 0.4,
            },
            env = {
                cargo = {
                    RUST_LOG = 'debug',
                },
            },
            binary = {
                python = 'python3',
            },
        },
        picker_list = {
            opts = {
                project = { display_type = 'full' },
                emoji = require('telescope.themes').get_dropdown(),
                -- TODO: Luasnip - Snippet engine
                -- luasnip = require('telescope.themes').get_dropdown,
                -- TODO: Noice - notify engine
                -- notify = require('telescope.themes').get_dropdown,
            },
            user_pickers = {
                {
                    "todo-comments",
                    function()
                        vim.cmd([[TodoTelescope ]])
                    end,
                },
                {
                    'urlview local',
                    function()
                        vim.cmd([[UrlView]])
                    end,
                },
                {
                    'urlview lazy',
                    function()
                        vim.cmd([[UrlView lazy]])
                    end,
                },
            },
        },
        emoji = {
        action = function(emoji)
            -- argument emoji is a table.
            -- {name="", value="", cagegory="", description=""}

            vim.fn.setreg("*", emoji.value)
            print([[Press p or "*p to paste this emoji]] .. emoji.value)

            -- insert emoji when picked
            -- vim.api.nvim_put({ emoji.value }, 'c', false, true)
        end,
        },
        helpgrep = {
            ignore_paths = {
                vim.fn.stdpath('state') .. '/lazy/readme',
            },
        },
        lazy = {
            theme = 'ivy',
            mappings = {
                open_plugins_picker = ',',
            },
            actions_opts = {
                open_in_browser = {
                    auto_close = true,
                },
            },
        },
        lazy_plugins = {
            lazy_config = vim.fn.stdpath('config') .. "/init.lua",
        },
        resession = {},
        workspaces ={
            keep_insert = false,
        },
        git_diffs = {
            git_command = { 'git', 'log', '--oneline', '--decorate', '--all', '.' }
        },
	},
})
