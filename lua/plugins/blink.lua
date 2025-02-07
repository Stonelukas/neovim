---@module "lazy"
---@type LazySpec
return {
	{
		"saghen/blink.compat",
		version = "*",
		lazy = true,
		opts = {},
	},
	{
		"saghen/blink.cmp",
		-- optional: provides snippets for the snippet source
		dependencies = {
			"rafamadriz/friendly-snippets",
			"dmitmel/cmp-digraphs",
			"folke/lazydev.nvim",
			"mikavilpas/blink-ripgrep.nvim",
			"moyiz/blink-emoji.nvim",
		},
		-- use a release tag to download pre-built binaries
		version = "*",
		build = "cargo build --release",

		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {

			keymap = {
				preset = "super-tab",
				-- scroll documentation
				["<Tab>"] = { "select_and_accept", "fallback" },
				["<S-Tab>"] = { "snippet_backward", "fallback" },
				["<C-d>"] = { "scroll_documentation_down" },
				["<C-u>"] = { "scroll_documentation_up" },
				["<A-1>"] = {
					function(cmp)
						cmp.accept({ index = 1 })
					end,
				},
				["<A-2>"] = {
					function(cmp)
						cmp.naccept({ index = 2 })
					end,
				},
				["<A-3>"] = {
					function(cmp)
						cmp.accept({ index = 3 })
					end,
				},
				["<A-4>"] = {
					function(cmp)
						cmp.accept({ index = 4 })
					end,
				},
				["<A-5>"] = {
					function(cmp)
						cmp.accept({ index = 5 })
					end,
				},
				["<A-6>"] = {
					function(cmp)
						cmp.accept({ index = 6 })
					end,
				},
				["<A-7>"] = {
					function(cmp)
						cmp.accept({ index = 7 })
					end,
				},
				["<A-8>"] = {
					function(cmp)
						cmp.accept({ index = 8 })
					end,
				},
				["<A-9>"] = {
					function(cmp)
						cmp.accept({ index = 9 })
					end,
				},
				["<A-0>"] = {
					function(cmp)
						cmp.accept({ index = 10 })
					end,
				},
			},
			appearance = {
				use_nvim_cmp_as_default = true,
				nerd_font_variant = "mono",
				kind_icons = {
					Text = "󰉿",
					Method = "󰊕",
					Function = "󰊕",
					Constructor = "󰒓",

					Field = "󰜢",
					Variable = "󰆦",
					Property = "󰖷",

					Class = "󱡠",
					Interface = "󱡠",
					Struct = "󱡠",
					Module = "󰅩",

					Unit = "󰪚",
					Value = "󰦨",
					Enum = "󰦨",
					EnumMember = "󰦨",

					Keyword = "󰻾",
					Constant = "󰏿",

					Snippet = "󱄽",
					Color = "󰏘",
					File = "󰈔",
					Reference = "󰬲",
					Folder = "󰉋",
					Event = "󱐋",
					Operator = "󰪚",
					TypeParameter = "󰬛",
				},
			},
			completion = {
				keyword = { range = "full" },
				-- TODO: Test if autpairs works with blink
				accept = {
					auto_brackets = { enabled = false },
					create_undo_point = true,
				},
				trigger = {
					prefetch_on_insert = true,
					show_on_trigger_character = true,
					show_on_accept_on_trigger_character = true,
					show_on_insert_on_trigger_character = true,
					show_in_snippet = true,
				},
				menu = {
					border = "rounded",
					max_height = 15,
					auto_show = true,
					draw = {
						align_to = "label",
						columns = {
							{ "item_idx" },
							{ "kind_icon" },
							{ "label", "label_description", gap = 1 },
							{ "kind" },
						},

						components = {
							item_idx = {
								text = function(ctx)
									return ctx.idx == 10 and "0" or ctx.idx >= 10 and " " or tostring(ctx.idx)
								end,
								highlight = "BlinkCmpItemIdx", -- optional, only if you want to change its color
							},
							kind_icon = {
								ellipsis = false,
								text = function(ctx)
									return ctx.kind_icon .. ctx.icon_gap
								end,
								highlight = function(ctx)
									return (
										require("blink.cmp.completion.windows.render.tailwind").get_hl(ctx)
										or "BlinkCmpKind"
									) .. ctx.kind
								end,
							},
							kind = {
								ellipsis = false,
								width = { fill = true },
								text = function(ctx)
									return ctx.kind
								end,
								highlight = function(ctx)
									return (
										require("blink.cmp.completion.windows.render.tailwind").get_hl(ctx)
										or "BlinkCmpKind"
									) .. ctx.kind
								end,
							},

							label = {
								width = { fill = true, max = 60 },
								text = function(ctx)
									return ctx.label .. ctx.label_detail
								end,
								highlight = function(ctx)
									-- label and label details
									local highlights = {
										{
											0,
											#ctx.label,
											group = ctx.deprecated and "BlinkCmpLabelDeprecated" or "BlinkCmpLabel",
										},
									}
									if ctx.label_detail then
										table.insert(highlights, {
											#ctx.label,
											#ctx.label + #ctx.label_detail,
											group = "BlinkCmpLabelDetail",
										})
									end

									-- characters matched on the label by the fuzzy matcher
									for _, idx in ipairs(ctx.label_matched_indices) do
										table.insert(highlights, { idx, idx + 1, group = "BlinkCmpLabelMatch" })
									end

									return highlights
								end,
							},

							label_description = {
								width = { max = 30 },
								text = function(ctx)
									return ctx.label_description
								end,
								highlight = "BlinkCmpLabelDescription",
							},
						},
						treesitter = { "lsp" },
					},
				},
				documentation = {
					auto_show = true,
					window = {
						border = "rounded",
					},
				},
				list = {
					selection = {
						auto_insert = false,
						preselect = function(ctx)
							return not require("blink.cmp").snippet_active({ direction = 1 })
						end,
					},
				},
			},

			sources = {
				default = {
					"lazydev",
					"lsp",
					"path",
					"snippets",
					"path",
					"buffer",
					"ripgrep",
					"emoji",
					"digraphs",
					"avante_commands",
					"avante_mentions",
					"avante_files",
				},
				providers = {
					lazydev = {
						name = "LazyDev",
						module = "lazydev.integrations.blink",
						score_offset = 1000,
					},
					lsp = {
						name = "LSP",
						module = "blink.cmp.sources.lsp",
						transform_items = function(_, items)
							for _, item in ipairs(items) do
								if item.kind == require("blink.cmp.types").CompletionItemKind.Snippet then
									item.score_offset = item.score_offset - 3
								end
								item.labelDetails = {
									description = "(lsp)",
								}
							end
							return vim.tbl_filter(function(item)
								return item.kind ~= require("blink.cmp.types").CompletionItemKind.Text
							end, items)
						end,
					},
					buffer = {
						name = "Buffer",
						module = "blink.cmp.sources.buffer",
						score_offset = 1,
						opts = {
							get_bufnrs = function()
								return vim.iter(vim.api.nvim_list_wins())
									:map(function(win)
										return vim.api.nvim_win_get_buf(win)
									end)
									:filter(function(buf)
										return vim.bo[buf].buftype ~= "nofile"
									end)
									:totable()
							end,
						},
						transform_items = function(_, items)
							for _, item in ipairs(items) do
								item.labelDetails = {
									description = "(buffer)",
								}
							end
							return items
						end,
					},
					path = {
						name = "Path",
						module = "blink.cmp.sources.path",
						score_offset = 3,
						opts = {
							trailing_slash = true,
							label_trailing_slash = true,
							get_cwd = function(context)
								return vim.fn.expand(("#%d:p:h"):format(context.bufnr))
							end,
							show_hidden_files_by_default = true,
						},
						transform_items = function(_, items)
							for _, item in ipairs(items) do
								item.labelDetails = {
									description = " ",
								}
							end
							return items
						end,
					},
					snippets = {
						name = "Snippets",
						module = "blink.cmp.sources.snippets",
						opts = {
							friendly_snippets = true,
							search_paths = { vim.fn.stdpath("config") .. "/snippets" },
							global_snippets = { "all" },
							get_filetype = function(context)
								return vim.bo.filetype
							end,
							-- Set to '+' to use the system clipboard, or '"' to use the unnamed register
							clipboard_register = "+",
						},
					},
					digraphs = {
						enabled = false,
						name = "digraphs",
						module = "blink.compat.source",
						score_offset = 1,
						opts = {
							cache_digraphs_on_start = true,
						},

						transform_items = function(_, items)
							for _, item in ipairs(items) do
								item.labelDetails = {
									description = "(digraphs)",
								}
							end
							return items
						end,
					},
					emoji = {
						module = "blink-emoji",
						name = "Emoji",
						score_offset = 2,
						opts = { insert = true },
					},
					ripgrep = {
						enabled = false,
						module = "blink-ripgrep",
						name = "Ripgrep",
						-- the options below are optional, some default values are shown
						---@module "blink-ripgrep"
						---@type blink-ripgrep.Options
						opts = {
							prefix_min_len = 5,
							context_size = 5,
							max_filesize = "1M",
							project_root_marker = ".git",
							search_casing = "--ignore-case",
							additional_rg_options = {},
							fallback_to_regex_highlighting = true,
							debug = false,
							future_features = {
								kill_previous_searches = true,
							},
						},
						transform_items = function(_, items)
							for _, item in ipairs(items) do
								item.labelDetails = {
									description = "(rg)",
								}
							end
							return items
						end,
					},
					avante_commands = {
						name = "avante_commands",
						module = "blink.compat.source",
						score_offset = 90, -- show at a higher priority than lsp
						opts = {},
					},
					avante_files = {
						name = "avante_files",
						module = "blink.compat.source",
						score_offset = 100, -- show at a higher priority than lsp
						opts = {},
					},
					avante_mentions = {
						name = "avante_mentions",
						module = "blink.compat.source",
						score_offset = 1000, -- show at a higher priority than lsp
						opts = {},
					},
				},
			},
			snippets = { preset = "default" },
			signature = {
				enabled = true,
				trigger = {
					show_on_insert_on_trigger_character = true,
				},
			},
			fuzzy = {
				-- use_typo_resistance = true,
				use_frecency = true,
				use_proximity = true,
			},
		},
		opts_extend = { "sources.default" },
	},
	{
		"saghen/blink.nvim",
		keys = {
			-- chartoggle
			{
				";",
				function()
					require("blink.chartoggle").toggle_char_eol(";")
				end,
				mode = { "n", "v" },
				desc = "Toggle ; at eol",
			},
			{
				",",
				function()
					require("blink.chartoggle").toggle_char_eol(",")
				end,
				mode = { "n", "v" },
				desc = "Toggle , at eol",
			},
		},
		-- all modules handle lazy loading internally
		lazy = false,
		opts = {
			chartoggle = { enabled = true },
			delimiters = { enabled = true },
			indent = { enabled = true },
			tree = { enabled = false },
		},
	},
}
