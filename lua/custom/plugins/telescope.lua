return {
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.7",
		dependencies = {
			"nvim-telescope/telescope-symbols.nvim",
			"nvim-lua/plenary.nvim",
			"mollerhoj/telescope-recent-files.nvim",
			"nvim-telescope/telescope-project.nvim",
			"nvim-telescope/telescope-file-browser.nvim",
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope-z.nvim",
			"octarect/telescope-menu.nvim",
			"jonarrien/telescope-cmdline.nvim",
			"jvgrootveld/telescope-zoxide",
			"tsakirist/telescope-lazy.nvim",
			"fdschmidt93/telescope-egrepify.nvim",
			"tiagovla/scope.nvim",
		},
		keys = {},
		config = function()
			local Layout = require("nui.layout")
			local Popup = require("nui.popup")
			local telescope = require("telescope")
			local telescopeConfig = require("telescope.config")
			local builtin = require("telescope.builtin")
			local action_layout = require("telescope.actions.layout")
			local action_state = require("telescope.actions.state")
			local fb_actions = require("telescope").extensions.file_browser.actions
			local z_utils = require("telescope._extensions.zoxide.utils")
			local open_with_trouble = require("trouble.sources.telescope").open

			-- Clone the default Telescope configuration
			local vimgrep_arguments = { unpack(telescopeConfig.values.vimgrep_arguments) }

			-- I want to search in hidden/dot files.
			table.insert(vimgrep_arguments, "--hidden")
			-- I don't want to search in the `.git` directory.
			table.insert(vimgrep_arguments, "--glob")
			table.insert(vimgrep_arguments, "!**/.git/*")

			telescope.setup({
				defaults = {
					-- `hidden = true` is not supported in text grep commands.
					vimgrep_arguments = {
						"rg",
						"--color=auto",
						"--no-heading",
						"--with-filename",
						"--line-number",
						"--column",
						"--smart-case",
						"--trim", -- add this value,
					},
				},
				pickers = {
					find_files = {
						-- `hidden = true` will still show the inside of `.git/` as it's not `.gitignore`d.
						find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
					},
					mappings = {
						n = {
							["<leader>tp"] = action_layout.toggle_preview,
							["<C-t>"] = open_with_trouble,
						},
						i = {
							["<C-g>"] = function(prompt_bufnr)
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
							["<A-p>"] = action_layout.toggle_preview,
						},
					},
				},

				extensions = {
					project = {
						base_dirs = {
							"~/.config",
							"~/github",
							"~/.config/nvim/",
						},
						hidden_files = true, -- default: false
						theme = "dropdown",
						order_by = "recent",
						search_by = "title",
						sync_with_nvim_tree = false, -- default false
						-- default for on_project_selected = find project files
						on_project_selected = function(prompt_bufnr) end,
					},
					menu = {
						filetype = {
							lua = {
								items = {
									{ "Format", "!stylua %" },
									{ "Open Luadev menu", "Luadev" },
									{ "Execute a current buffer", "LuaRun" },
								},
							},
						},
						default = {
							items = {
								-- You can add an item of menu in the form of { "<display>", "<command>" }
								{ "Checkhealth", "checkhealth" },
								{ "Show LSP Info", "LspInfo" },
								{ "Files", "Telescope find_files" },

								-- The above examples are syntax-sugars of the following;
								{ display = "Change colorscheme", value = "Telescope colorscheme" },
							},
						},
						editor = {
							items = {
								{ "Split window vertically", "vsplit" },
								{ "Split window horizontally", "split" },
								{ "Write", "w" },
							},
						},
					},
					cmdline = {
						picker = {
							layout_config = {
								width = 120,
								height = 25,
							},
						},
						mappings = {
							complete = "<Tab>",
							run_selection = "<C-CR>",
							run_input = "<CR>",
						},
					},
					zoxide = {
						prompt_title = "[ Zoxide List ]",

						-- Zoxide list command with score
						list_command = "zoxide query -ls",
						mappings = {
							default = {
								action = function(selection)
									vim.cmd.edit(selection.path)
								end,
								after_action = function(selection)
									print("Directory changed to " .. selection.path)
								end,
							},
							["<C-s>"] = { action = z_utils.create_basic_command("split") },
							["<C-v>"] = { action = z_utils.create_basic_command("vsplit") },
							["<C-e>"] = { action = z_utils.create_basic_command("edit") },
							["<C-b>"] = {
								keepinsert = true,
								action = function(selection)
									builtin.file_browser({ cwd = selection.path })
								end,
							},
							["<C-f>"] = {
								keepinsert = true,
								action = function(selection)
									builtin.find_files({ cwd = selection.path })
								end,
							},
							["<C-t>"] = {
								action = function(selection)
									vim.cmd.tcd(selection.path)
								end,
							},
						},
					},
					lazy = {
						-- Optional theme (the extension doesn't set a default theme)
						theme = "ivy",
						-- Whether or not to show the icon in the first column
						show_icon = true,
						-- Mappings for the actions
						mappings = {
							open_in_browser = "<C-o>",
							open_in_file_browser = "<M-b>",
							open_in_find_files = "<C-f>",
							open_in_live_grep = "<C-g>",
							open_in_terminal = "<C-t>",
							open_plugins_picker = "<C-b>", -- Works only after having called first another action
							open_lazy_root_find_files = "<C-r>f",
							open_lazy_root_live_grep = "<C-r>g",
							change_cwd_to_plugin = "<C-c>d",
						},
						-- Extra configuration options for the actions
						actions_opts = {
							open_in_browser = {
								-- Close the telescope window after the action is executed
								auto_close = false,
							},
							change_cwd_to_plugin = {
								-- Close the telescope window after the action is executed
								auto_close = false,
							},
						},
						-- Configuration that will be passed to the window that hosts the terminal
						-- For more configuration options check 'nvim_open_win()'
						terminal_opts = {
							relative = "editor",
							style = "minimal",
							border = "rounded",
							title = "Telescope lazy",
							title_pos = "center",
							width = 0.5,
							height = 0.5,
						},
						-- Other telescope configuration options
					},
					aerial = {
						show_nesting = {
							["_"] = false,
							json = true,
							toml = true,
						},
					},
				},
			})
			-- recent files extension
			require("telescope").load_extension("recent-files")

			vim.keymap.set("n", "<leader>f", function()
				require("telescope").extensions["recent-files"].recent_files({})
			end, { noremap = true, silent = true })

			-- project extension
			require("telescope").load_extension("project")

			vim.keymap.set("n", "<leader>tp", function()
				require("telescope").extensions.project.project({ display_type = "full" })
			end, { noremap = true, silent = true })

			-- telescope file browser extension
			require("telescope").load_extension("file_browser")

			vim.keymap.set("n", "<space>fb", function()
				require("telescope").extensions.file_browser.file_browser()
			end)

			-- telescope z extensions
			require("telescope").load_extension("z")

			-- telescope menu
			require("telescope").load_extension("menu")

			-- cmdline extension
			--[[ require("telescope").load_extension("cmdline")

			vim.api.nvim_set_keymap("n", ":", ":Telescope cmdline<CR>", { noremap = true, desc = "Cmdline" }) ]]

			-- telescope zoxide
			telescope.load_extension("zoxide")

			vim.keymap.set("n", "<leader>cd", telescope.extensions.zoxide.list)

			-- telescope lazy extensions
			require("telescope").load_extension("lazy")

			vim.api.nvim_set_keymap("n", "<leader>ll", ":Telescope lazy<CR>", { noremap = true, desc = "Lazy Plugins" })

			-- egrepify extensions
			require("telescope").load_extension("egrepify")

			-- scope extensions
			require("telescope").load_extension("scope")

			-- noice extension
			require("telescope").load_extension("noice")

			-- aerial extension
			require("telescope").load_extension("aerial")

			-- basic keybindings

			vim.keymap.set("n", "<C-p>", function()
				require("telescope.builtin").find_files({ previewer = true })
			end)
			vim.keymap.set("n", "<leader>.", function()
				builtin.find_files({ cwd = vim.fn.expand("%:p:h") })
			end)
			vim.keymap.set("n", "<leader>fg", function()
				require("telescope.builtin").live_grep({})
			end)
			vim.keymap.set("n", "<leader>fh", function()
				require("telescope.builtin").help_tags({})
			end)
			vim.keymap.set("n", "<leader>ft", function()
				require("telescope.builtin").tags({})
			end)
			vim.keymap.set("n", "<leader><leader>", function()
				require("telescope.builtin").oldfiles({})
			end)
			vim.keymap.set("n", "<leader>bu", function()
				require("telescope.builtin").buffers({ sort_lastused = true })
			end)
			vim.keymap.set("n", "<leader>cb", function()
				require("telescope.builtin").current_buffers_fuzzy_find({})
			end)

			require("commander").setup({
				integration = {
					lazy = {
						enable = false,
						set_plugin_name_as_cat = true,
					},
					telescope = {
						enable = true,
						theme = require("telescope.themes").commander,
					},
				},
			})
		end,
	},
	{
		"nvim-telescope/telescope-ui-select.nvim",
		config = function()
			require("telescope").setup({
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown({}),
					},
				},
			})
			require("telescope").load_extension("ui-select")
		end,
	},

	{
		"nvim-telescope/telescope-fzf-native.nvim",
		-- NOTE: If you have trouble with this installation, refer to the README for telescope-fzf-native.
		build = "make",
		config = function()
			require("telescope").load_extension("fzf")
		end,
	},
}
