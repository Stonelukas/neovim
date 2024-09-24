return {
	{
		"romgrk/barbar.nvim",
		version = "^1.0.0",
		cond = true,
		init = function()
			vim.g.barbar_auto_setup = false
		end,
		config = function()
			require("barbar").setup({
				animation = true,
				tabpages = true,
				clickable = true,
				maximum_padding = math.huge,
                highlight_visible = true,
				icons = {
                    default = 'slanted',
					buffer_number = false,
                    button = "",
                    diagnostics = {
                        [vim.diagnostic.severity.ERROR] = { enabled = true, icon = " " },
                        [vim.diagnostic.severity.WARN] = { enabled = true },
                        [vim.diagnostic.severity.INFO] = { enabled = true },
                        [vim.diagnostic.severity.HINT] = { enabled = true },
                    },
                    gitsigns = {
                        added = { enabled = true, icon = " " },
                        changed = { enabled = true, icon = "󱗝 " },
                        deleted = { enabled = true, icon = "󰆴 " },
                    },
					pinned = { button = "", filename = true },
					filetype = {
						custom_colors = false,
                        enabled = true,
					},
					alternate = {
						filetype = { enabled = false },
					},
					current = {},
					inactive = {},
					visible = {
						modified = {},
					},
                    separator = {left = '▎', right = ''},
                    seperator_at_end = true,
				},
				sidebar_filetypes = {
					undotree = {
						text = "undotree",
						align = "center",
					},
                    ['NvimTree'] = {
                        -- text = 'Nvimtree',
                        event = 'BufWipeout',
                    },
					["neo-tree"] = {
						event = "BufWipeout",
						text = "neo-tree",
						align = "center",
					},
                    outline = {
                        event = 'BufWinLeave',
                        text = 'symbols-outline',
                        align = 'right',
                    },
				},
			})

            require('plugins.config.barbar')
		end,
	},
	{
		"miversen33/nvim-cokeline",
		priority = 800,
		cond = false,
		config = function()
			local get_hex = require("cokeline.hlgroups").get_hl_attr
			local mappings = require("cokeline.mappings")
			local comments_fg = get_hex("Comment", "fg")
			local errors_fg = get_hex("DiagnosticError", "fg")
			local warnings_fg = get_hex("DiagnosticWarn", "fg")
			local red = vim.g.terminal_color_1
			local green = vim.g.terminal_color_2
			local yellow = vim.g.terminal_color_3

			local hlgroups = require("cokeline.hlgroups")
			local hl_attr = hlgroups.get_hl_attr

			local components = {
				space = {
					text = " ",
					truncation = { priority = 1 },
				},
				two_spaces = {
					text = "  ",
					truncation = { priority = 1 },
				},
				separator = {
					text = function(buffer)
						return buffer.index ~= 1 and "| " or ""
					end,
					truncation = { priority = 1 },
				},
				devicon = {
					text = function(buffer)
						return (mappings.is_picking_focus() or mappings.is_picking_close())
								and buffer.pick_letter .. " "
							or buffer.devicon.icon
					end,
					fg = function(buffer)
						return (mappings.is_picking_focus() and yellow)
							or (mappings.is_picking_close() and red)
							or buffer.devicon.color
					end,
					style = function(_)
						return (mappings.is_picking_focus() or mappings.is_picking_close()) and "italic,bold" or nil
					end,
					truncation = { priority = 1 },
				},
				index = {
					text = function(buffer)
						return buffer.index .. ": "
					end,
					trucation = { priority = 1 },
				},
				unique_prefix = {
					text = function(buffer)
						return buffer.unique_prefix
					end,
					fg = comments_fg,
					style = "italic",
					truncation = {
						priority = 3,
						direction = "left",
					},
				},
				filename = {
					text = function(buffer)
						return buffer.filename
					end,
					style = function(buffer)
						return ((buffer.is_focused and buffer.diagnostics.errors ~= 0) and "bold,underline")
							or (buffer.is_focused and "bold")
							or (buffer.diagnostics.errors ~= 0 and "underline")
							or nil
					end,
					truncation = {
						priority = 2,
						direction = "left",
					},
				},
				diagnostics = {
					text = function(buffer)
						return (buffer.diagnostics.errors ~= 0 and " 󰅚 " .. buffer.diagnostics.errors)
							or (buffer.diagnostics.warnings ~= 0 and " 󰅚 " .. buffer.diagnostics.warnings)
							or ""
					end,
					fg = function(buffer)
						return (buffer.diagnostics.errors ~= 0 and errors_fg)
							or (buffer.diagnostics.warnings ~= 0 and warnings_fg)
							or nil
					end,
					truncation = { priority = 1 },
				},
				close_or_unsaved = {
					text = function(buffer)
						return buffer.is_modified and "●" or "󰅚"
					end,
					fg = function(buffer)
						return buffer.is_modified and green or nil
					end,
					delete_buffer_on_left_click = true,
					truncation = { priority = 1 },
				},
			}

			require("cokeline").setup({
				show_if_buffers_are_at_least = 1,
				buffers = {
					filter_valid = false,
					focus_on_delete = "next", -- or 'prev'
					new_buffers_position = "last", -- or 'next', 'directory', 'number'
					delete_on_right_click = true,
				},
				mappings = {
					disable_mouse = false,
				},
				history = {
					enabled = true,
					size = 20,
				},
				rendering = {
					max_buffer_width = 999,
				},
				pick = {
					use_filename = true,
					letters = "asdfjkl;ghnmxcvbziwerutyqpASDFJKLGHNMXCVBZIOWERTYQP",
				},
				default_hl = {
					fg = function(buffer)
						return buffer.is_focused and get_hex("Normal", "fg") or get_hex("Comment", "fg")
					end,
					bg = get_hex("ColorColumn", "bg"),
					sp = nil,
					bold = nil,
					italic = nil,
					underline = nil,
					undercurl = nil,
					strikethrough = nil,
				},
				fill_hl = "TabLineFill",
				components = {
					components.space,
					components.separator,
					components.space,
					components.devicon,
					components.space,
					components.index,
					components.unique_prefix,
					components.filename,
					components.diagnostics,
					components.two_spaces,
					components.close_or_unsaved,
					components.space,
				},
				rhs = {},
				tabs = {
					placement = "right", -- or "left"
					components = {},
				},
				sidebar = {
					-- filetype = "neo-tree",
					-- components = {
					--     {
					--         text = function(buf)
					--             return vim.bo[buf.number].filetype
					--         end,
					--         fg = yellow,
					--         bg = function() return get_hex('NeoTreeNormal', 'bg') end,
					--         bold = true,
					--     },
					-- },
					filetype = { "NvimTree", "neo-tree" },
					components = {
						{
							text = " 󰙅  File Explorer ",
							fg = yellow,
							bg = yellow,
							bold = true,
						},
					},
				},
			})

			vim.keymap.set("n", "<S-Tab>", function()
				return ("<Plug>(cokeline-focus-%s)"):format(vim.v.count > 0 and vim.v.count or "prev")
			end, { silent = true, expr = true, desc = "focus Next buffer" })
			vim.keymap.set("n", "<Tab>", function()
				return ("<Plug>(cokeline-focus-%s)"):format(vim.v.count > 0 and vim.v.count or "next")
			end, { silent = true, expr = true, desc = "focus Next buffer" })
			vim.api.nvim_set_keymap(
				"n",
				"<leader>p",
				"<Plug>(cokeline-switch-prev)",
				{ silent = true, desc = "switch to Previous buffer" }
			)
			vim.api.nvim_set_keymap(
				"n",
				"<leader>n",
				"<Plug>(cokeline-switch-next)",
				{ silent = true, desc = "switch to Next buffer" }
			)
			vim.keymap.set("n", "<leader>bc", function()
				require("cokeline.mappings").pick("close")
			end, { silent = true, desc = "close picked buffer" })
			vim.keymap.set("n", "<leader>bp", function()
				require("cokeline.mappings").pick("focus")
			end, { silent = true, desc = "open picked buffer" })
		end,
	},
}
