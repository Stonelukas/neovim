return {
	{
		"arkav/lualine-lsp-progress",
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			local custom_fname = require("lualine.components.filename"):extend()
			local colors = {
				yellow = "#ECBE7B",
				cyan = "#008080",
				darkblue = "#081633",
				green = "#98be65",
				orange = "#FF8800",
				violet = "#a9a1e1",
				magenta = "#c678dd",
				blue = "#51afef",
				red = "#ec5f67",
			}

			local function trunc(trunc_width, trunc_len, hide_width, no_ellipsis)
				return function(str)
					local win_width = vim.fn.winwidth(0)
					if hide_width and win_width < hide_width then
						return ""
					elseif trunc_width and trunc_len and win_width < trunc_width and #str > trunc_len then
						return str:sub(1, trunc_len) .. (no_ellipsis and "" or "...")
					end
					return str
				end
			end

			local config = {
				options = {
					icons_enabled = true,
					theme = "tokyonight",
					component_separators = { left = "", right = "" },
					section_separators = { left = "", right = "" },
					disabled_filetypes = {
						statusline = {},
						winbar = {},
					},
					ignore_focus = {},
					always_divide_middle = true,
					globalstatus = true,
					refresh = {
						statusline = 1000,
						tabline = 1000,
						winbar = 1000,
					},
				},
				sections = {
					lualine_a = {
						{ "mode", fmt = trunc(80, 4, nil, true) },
						{
							function()
								return require("lsp-status").status()
							end,
							fmt = trunc(120, 20, 60),
						},
					},
					lualine_b = {
						"branch",
						"diff",
						{
							"diagnostics",
							sources = { "nvim_diagnostic", "nvim_lsp" },
							sections = { "error", "warn", "info", "hint" },
							colored = true,
							always_visible = false,
						},
					},
					lualine_c = {
						{
							"windows",
							show_filename_only = true,
							show_modified_status = true,
							filetype_names = {
								TelescopePrompt = "Telescope",
								dashboard = "Dashbord",
								packer = "Packer",
								fzf = "FZF",
								alpha = "Alpha",
							},
							use_mode_colors = true,
						},
						--[[ {
                        "filename",
                        file_status = true,
                        path = 0,
                        symbols = {
                            modified = "[+]", -- Text to show when the file is modified.
                            readonly = "[-]", -- Text to show when the file is non-modifiable or readonly.
                            unnamed = "[No Name]", -- Text to show for unnamed buffers.
                            newfile = "[New]", -- Text to show for newly created file before first write
                        },
                    }, ]]
						require("auto-session.lib").current_session_name,
					},
					lualine_x = {
						{
							require("noice").api.statusline.mode.get,
							cond = require("noice").api.statusline.mode.has,
							color = { fg = "#ff9e64" },
						},
						"encoding",
						"fileformat",
						"filetype",
					},
					lualine_y = { "progress" },
					lualine_z = { "location", "searchcount", "selectioncount" },
				},
				inactive_sections = {
					lualine_a = {},
					lualine_b = {},
					lualine_c = { "filename" },
					lualine_x = { "location" },
					lualine_y = {},
					lualine_z = {},
				},
				tabline = {},
				winbar = {
					lualine_a = {},
					lualine_b = {},
					lualine_c = {},
					lualine_x = {},
					lualine_y = {},
					lualine_z = {},
				},
				inactive_winbar = {},
				extensions = {
					"quickfix",
					"ctrlspace",
					"fzf",
					"lazy",
					"man",
					"mason",
					"neo-tree",
					"nerdtree",
					"oil",
					"toggleterm",
				},
			}

			-- Inserts a component in lualine_c at left section
			local function ins_left(component)
				table.insert(config.sections.lualine_c, component)
			end

			-- Inserts a component in lualine_x ot right section
			local function ins_right(component)
				table.insert(config.sections.lualine_x, component)
			end

			ins_left({
				"lsp_progress",
				display_components = { "lsp_client_name", { "title", "percentage", "message" } },
				-- With spinner
				-- display_components = { 'lsp_client_name', 'spinner', { 'title', 'percentage', 'message' }},
				colors = {
					percentage = colors.cyan,
					title = colors.cyan,
					message = colors.cyan,
					spinner = colors.cyan,
					lsp_client_name = colors.magenta,
					use = true,
				},
				separators = {
					component = " ",
					progress = " | ",
					message = { pre = "(", post = ")" },
					percentage = { pre = "", post = "%% " },
					title = { pre = "", post = ": " },
					lsp_client_name = { pre = "[", post = "]" },
					spinner = { pre = "", post = "" },
				},
				timer = { progress_enddelay = 500, spinner = 1000, lsp_client_name_enddelay = 1000 },
				spinner_symbols = { "🌑 ", "🌒 ", "🌓 ", "🌔 ", "🌕 ", "🌖 ", "🌗 ", "🌘 " },
			})

			require("lualine").setup(config)
		end,
	},
}
