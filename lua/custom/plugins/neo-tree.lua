return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
		--"3rd/image/nui.nvim",
	},
	config = function()
		vim.fn.sign_define("DiagnosticSignError", { text = " ", texthl = "DiagnosticSignError" })
		vim.fn.sign_define("DiagnosticSignWarn", { text = " ", texthl = "DiagnosticSignWarn" })
		vim.fn.sign_define("DiagnosticSignInfo", { text = " ", texthl = "DiagnosticSignInfo" })
		vim.fn.sign_define("DiagnosticSignHint", { text = "󰌵", texthl = "DiagnosticSignHint" })
		require("neo-tree").setup({
			enable_diagnostics = true,
			popup_border_style = "rounded",
			enable_git_status = true,
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
			default_component_configs = {
				container = {
					enable_character_fade = true,
				},
				indent = {
					indent_size = 2,
					padding = 1, -- extra padding on left hand side
					-- indent guides
					with_markers = true,
					indent_marker = "│",
					last_indent_marker = "└",
					highlight = "NeoTreeIndentMarker",
					-- expander config, needed for nesting files
					with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
					expander_collapsed = "",
					expander_expanded = "",
					expander_highlight = "NeoTreeExpander",
				},
				icon = {
					folder_closed = "",
					folder_open = "",
					folder_empty = "󰜌",
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
			},
			commands = {},
			window = {
				position = "left",
				width = 50,
				mapping_options = {
					noremap = true,
					nowait = true,
				},
				popup = {
					position = { col = "100%", row = "2" },
					size = function(state)
						local root_name = vim.fn.fnamemodify(state.path, ":~")
						local root_len = string.len(root_name) + 4
						return {
							width = math.max(root_len, 50),
							height = vim.o.lines - 6,
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
						vim.api.nvim_exec2("Neotree focus git_status left", {})
					end,
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
					hide_dotfiles = true,
					hide_gitignored = true,
					hide_hidden = true, -- only works on Windows for hidden files/directories
					hide_by_name = {},
					hide_by_pattern = {},
					always_show = {},
					never_show = {},
					never_show_by_pattern = {},
				},
			},
			source_selector = {
				winbar = true,
				statusline = true,
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
				},
				content_layout = "start", -- string
				tabs_layout = "equal", -- string
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
			},
		})
		vim.keymap.set("n", "<leader>ä", ":Neotree <CR>", { noremap = true, silent = true })
	end,
}
