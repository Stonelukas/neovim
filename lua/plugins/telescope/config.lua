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
local actions = require("telescope.actions")

-- Clone the default Telescope configuration
local vimgrep_arguments = { unpack(telescopeConfig.values.vimgrep_arguments) }

-- I want to search in hidden/dot files.
table.insert(vimgrep_arguments, "--hidden")
-- I don't want to search in the `.git` directory.
table.insert(vimgrep_arguments, "--glob")
table.insert(vimgrep_arguments, "!**/.git/*")
local function flash(prompt_bufnr)
	require("flash").jump({
		pattern = "^",
		label = { after = { 0, 0 } },
		search = {
			mode = "search",
			exclude = {
				function(win)
					return vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= "TelescopeResults"
				end,
			},
		},
		action = function(match)
			local picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
			picker:set_selection(match.pos[1] - 1)
		end,
	})
end

telescope.setup({
	defaults = {
		dynamic_preview_title = true,
		preview = {
			treesitter = true,
		},
		set_env = {
			COLORTERM = "truecolor",
		},
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
		prompt_prefix = "> ",
		mappings = {
			n = {
				["<leader>tp"] = action_layout.toggle_preview,
				["<C-t>"] = open_with_trouble,
				s = flash,
			},
			i = {
				["<c-h>"] = "which_key",
				["<c-s>"] = actions.cycle_previewers_next,
				["<c-a>"] = actions.cycle_previewers_prev,
				["<A-p>"] = action_layout.toggle_preview,
				["<c-l>"] = flash,
				["<c-g>"] = function(prompt_bufnr)
					-- use nvim-window-picker to choose the window by dynamically attaching a function
					local action_set = require("telescope.actions.set")
					local action_state = require("telescope.actions.state")

					local picker = action_state.get_current_picker(prompt_bufnr)
					picker.get_selection_window = function(picker, entry)
						local picked_window_id = require("window-picker").pick_window()
							-- or vim.api.nvim_get_current_win()
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
			-- `hidden = true` will still show the inside of `.git/` as it's not `.gitignore`d.
			find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
			buffers = {
				show_all_buffers = true,
				sort_lastused = true,
			},
		},
	},

	extensions = {
		package_info = {
			theme = "ivy",
		},
		cder = {
			previewer = true,
			theme = "ivy",
			previewer_command = "exa "
				.. "-a "
				.. "--color=always "
				.. "-T "
				.. "--level=3 "
				.. "--icons "
				.. "--git-ignore "
				.. "--long "
				.. "--no-permissions "
				.. "--no-user "
				.. "--no-filesize "
				.. "--git "
				.. "--ignore-glob=.git",
			mappings = {
				["<C-t>"] = function(directory)
					vim.cmd.tcd(directory)
					vim.cmd([[tabnew]])
					vim.cmd([[Telescope find_files]])
				end,
			},
		},
		workspaces = {
			keep_insert = true,
		},
		project = {
			base_dirs = { "~/github", "~/.config/nvim/", "~/dotfiles/" },
			hidden_files = true, -- default: false
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
				items = { -- You can add an item of menu in the form of { "<display>", "<command>" }
					{ "Checkhealth", "checkhealth" },
					{ "Show LSP Info", "LspInfo" },
					{ "Files", "Telescope find_files" },

					-- The above examples are syntax-sugars of the following;
					{
						display = "Change colorscheme",
						value = "Telescope colorscheme",
					},
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
		zoxide = {
			prompt_title = "[ Zoxide List ]",

			-- Zoxide list command with score
			list_command = "zoxide query -ls",
			mappings = {
				default = {
					action = function(selection)
						vim.cmd.tcd(selection.path)
						vim.cmd([[tabnew]])
						vim.cmd([[telescope find_files]])
					end,
					after_action = function(selection)
						print("Directory changed to (" .. selection.z_score .. ") " .. selection.path)
					end,
				},
				["<C-s>"] = {
					action = z_utils.create_basic_command("split"),
				},
				["<C-v>"] = {
					action = z_utils.create_basic_command("vsplit"),
				},
				["<C-e>"] = {
					action = z_utils.create_basic_command("edit"),
				},
				["<C-b>"] = {
					keepinsert = true,
					action = function(selection)
						builtin.file_browser({
							cwd = selection.path,
						})
					end,
				},
				["<C-f>"] = {
					keepinsert = true,
					action = function(selection)
						builtin.find_files({
							cwd = selection.path,
						})
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
				open_plugins_picker = ",", -- Works only after having called first another action
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
		repo = {
			list = {
				search_dirs = { "~/dotfiles", "~/github", "~/.local/share/nvim" },
			},
		},
		heading = {
			treesitter = true,
			picker_opts = {
				layout_config = {
					width = 0.8,
					preview_width = 0.5,
				},
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
			theme = "ivy",
			compose_binary = "docker compose",
			buildx_binary = "docker buildx",
			machine_binary = "docker-machine",
			init_term = "tabnew",
		},
		tasks = {
			theme = "ivy",
			output = {
				style = "float",
				layout = "center",
				scale = 0.4,
			},
			env = {
				cargo = {
					RUST_LOG = "debug",
				},
			},
			binary = {
				python = "python3",
			},
		},
		picker_list = {
			opts = {
				project = {
					display_type = "full",
				},
				emoji = require("telescope.themes").get_dropdown(),
				luasnip = require("telescope.themes").get_dropdown(),
				notify = require("telescope.themes").get_dropdown(),
			},
			user_pickers = {
				{
					"todo-comments",
					function()
						vim.cmd([[TodoTelescope ]])
					end,
				},
				{
					"urlview local",
					function()
						vim.cmd([[UrlView]])
					end,
				},
				{
					"urlview lazy",
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
			ignore_paths = { vim.fn.stdpath("state") .. "/lazy/readme" },
		},
		lazy_plugins = {
			lazy_config = vim.fn.stdpath("config") .. "/init.lua",
		},
		resession = {},
		git_diffs = {
			git_command = { "git", "log", "--oneline", "--decorate", "--all", "." },
		},
	},
})
