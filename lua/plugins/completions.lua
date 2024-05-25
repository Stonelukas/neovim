return {
	{
		"hrsh7th/cmp-nvim-lsp",
	},
	{
		"tamago324/cmp-zsh",
		config = function()
			require("cmp_zsh").setup({
				zshrc = true,
				filetypes = { "deoledit", "zsh" },
			})
		end,
	},
	{
		"Shougo/deol.nvim",
	},
	{
		"jmbuhr/otter.nvim",
	},
	{
		"lukas-reineke/cmp-rg",
	},
	{
		"rasulomaroff/cmp-bufname",
	},
	{
		"amarakon/nvim-cmp-buffer-lines",
	},
	{
		"hrsh7th/cmp-path",
	},
	{
		"hrsh7th/cmp-cmdline",
	},
	{
		"hrsh7th/cmp-buffer",
	},
	{
		"petertriho/cmp-git",
	},
	{
		"onsails/lspkind.nvim",
	},
	{
		"nvim-tree/nvim-web-devicons",
	},
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = function()
			local npairs = require("nvim-autopairs")
			local Rule = require("nvim-autopairs.rule")

			local cond = require("nvim-autopairs.conds")
			local brackets = { { "(", ")" }, { "[", "]" }, { "{", "}" } }
			local endwise = require("nvim-autopairs.ts-rule").endwise

			npairs.setup({
				check_ts = true,
				ts_config = {
					lua = { "string" }, -- it will not add a pair on that treesitter node
					javascript = { "template_string" },
					java = false, -- don't check treesitter on java
				},
				enable_check_brackets_line = false,
			})

			npairs.add_rules(require("nvim-autopairs.rules.endwise-lua"))
			-- npairs.add_rules(require("nvim-autopairs.conds"))

			npairs.add_rules({
				-- Rule for a pair with left-side ' ' and right side ' '
				Rule(" ", " ")
					-- Pair will only occur if the conditional function returns true
					:with_pair(function(opts)
						-- We are checking if we are inserting a space in (), [], or {}
						local pair = opts.line:sub(opts.col - 1, opts.col)
						return vim.tbl_contains({
							brackets[1][1] .. brackets[1][2],
							brackets[2][1] .. brackets[2][2],
							brackets[3][1] .. brackets[3][2],
						}, pair)
					end)
					:with_move(cond.none())
					:with_cr(cond.none())
					-- We only want to delete the pair of spaces when the cursor is as such: ( | )
					:with_del(
						function(opts)
							local col = vim.api.nvim_win_get_cursor(0)[2]
							local context = opts.line:sub(col - 1, col + 2)
							return vim.tbl_contains({
								brackets[1][1] .. "  " .. brackets[1][2],
								brackets[2][1] .. "  " .. brackets[2][2],
								brackets[3][1] .. "  " .. brackets[3][2],
							}, context)
						end
					),
			})
			-- For each pair of brackets we will add another rule
			for _, bracket in pairs(brackets) do
				npairs.add_rules({
					-- Each of these rules is for a pair with left-side '( ' and right-side ' )' for each bracket type
					Rule(bracket[1] .. " ", " " .. bracket[2])
						:with_pair(cond.none())
						:with_move(function(opts)
							return opts.char == bracket[2]
						end)
						:with_del(cond.none())
						:use_key(bracket[2])
						-- Removes the trailing whitespace that can occur without this
						:replace_map_cr(function(_)
							return "<C-c>2xi<CR><C-c>O"
						end),
				})
			end

			function rule2(a1, ins, a2, lang)
				npairs.add_rule(Rule(ins, ins, lang)
					:with_pair(function(opts)
						return a1 .. a2 == opts.line:sub(opts.col - #a1, opts.col + #a2 - 1)
					end)
					:with_move(cond.none())
					:with_cr(cond.none())
					:with_del(function(opts)
						local col = vim.api.nvim_win_get_cursor(0)[2]
						return a1 .. ins .. ins .. a2 == opts.line:sub(col - #a1 - #ins + 1, col + #ins + #a2) -- insert only works for #ins == 1 anyway
					end))
			end

			npairs.add_rule(Rule("then", "end"):end_wise(function(opts)
				return string.match(opts.line, "^%s*if") ~= nil
			end))

			npairs.add_rule(Rule(")", "end"):end_wise(function(opts)
				return string.match(opts.line, "^%s*function") ~= nil
			end))

			rule2("(", "*", ")", "ocaml")
			rule2("(*", " ", "*)", "ocaml")
			rule2("(", " ", ")")

			-- https://github.com/rstacruz/vim-closer/blob/master/autoload/closer.vim
			local get_closing_for_line = function(line)
				local i = -1
				local clo = ""

				while true do
					i, _ = string.find(line, "[%(%)%{%}%[%]]", i + 1)
					if i == nil then
						break
					end
					local ch = string.sub(line, i, i)
					local st = string.sub(clo, 1, 1)

					if ch == "{" then
						clo = "}" .. clo
					elseif ch == "}" then
						if st ~= "}" then
							return ""
						end
						clo = string.sub(clo, 2)
					elseif ch == "(" then
						clo = ")" .. clo
					elseif ch == ")" then
						if st ~= ")" then
							return ""
						end
						clo = string.sub(clo, 2)
					elseif ch == "[" then
						clo = "]" .. clo
					elseif ch == "]" then
						if st ~= "]" then
							return ""
						end
						clo = string.sub(clo, 2)
					end
				end

				return clo
			end

			-- npairs.remove_rule("(")
			-- npairs.remove_rule("{")
			-- npairs.remove_rule("[")
			--
			-- npairs.add_rule(Rule("[%(%{%[]", "")
			--     :use_regex(true)
			--     :replace_endpair(function(opts)
			--         return get_closing_for_line(opts.line)
			--     end)
			--     :end_wise(function(opts)
			--         -- Do not endwise if there is no closing
			--         return get_closing_for_line(opts.line) ~= ""
			--     end))

			local ts_conds = require("nvim-autopairs.ts-conds")

			-- press % => %% only while inside a comment or string
			npairs.add_rules({
				Rule("%", "%", "lua"):with_pair(ts_conds.is_ts_node({ "string", "comment" })),
				Rule("$", "$", "lua"):with_pair(ts_conds.is_not_ts_node({ "function" })),
			})
		end,
	},
	{
		"hrsh7th/cmp-nvim-lsp-signature-help",
	},
	{
		"danymat/neogen",
		config = true,
	},
	{
		"onsails/diaglist.nvim",
	},
	{
		"L3MON4D3/LuaSnip",
		run = "make install_jsregexp",
		dependencies = {
			"saadparwaiz1/cmp_luasnip",
			"rafamadriz/friendly-snippets",
		},
	},
	{
		"hrsh7th/nvim-cmp",
		event = { "InsertEnter", "CmdlineEnter" },
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			local lspkind = require("lspkind")
			local types = require("cmp.types")
			local str = require("cmp.utils.str")
			local cmp_buffer = require("cmp_buffer")
			local cmp_autopairs = require("nvim-autopairs.completion.cmp")
			local handlers = require("nvim-autopairs.completion.handlers")
			local compare = require("cmp.config.compare")

			local ts_node_func_parens_disabled = {
				-- ecma
				named_imports = true,
				-- rust
				use_declaration = true,
			}

			local default_handler = cmp_autopairs.filetypes["*"]["("].handler
			cmp_autopairs.filetypes["*"]["("].handler = function(char, item, bufnr, rules, commit_character)
				local node_type = ts_utils.get_node_at_cursor():type()
				if ts_node_func_parens_disabled[node_type] then
					if item.data then
						item.data.funcParensDisabled = true
					else
						char = ""
					end
				end
				default_handler(char, item, bufnr, rules, commit_character)
			end

			local has_words_before = function()
				unpack = unpack or table.unpack
				local line, col = unpack(vim.api.nvim_win_get_cursor(0))
				return col ~= 0
					and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
			end

			local t = function(str)
				return vim.api.nvim_replace_termcodes(str, true, true, true)
			end

			local kind_icons = {
				Text = "  ",
				Method = "  ",
				Function = "  ",
				Constructor = "  ",
				Field = "  ",
				Variable = "  ",
				Class = "  ",
				Interface = "  ",
				Module = "  ",
				Property = "  ",
				Unit = "  ",
				Value = "  ",
				Enum = "  ",
				Keyword = "  ",
				Snippet = "  ",
				Color = "  ",
				File = "  ",
				Reference = "  ",
				Folder = "  ",
				EnumMember = "  ",
				Constant = "  ",
				Struct = "  ",
				Event = "  ",
				Operator = "  ",
				TypeParameter = "  ",
			}

			require("luasnip.loaders.from_vscode").lazy_load()

			cmp.setup({
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
				view = {
					entries = { name = "custom", selection_order = "near_cursor" },
				},
				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},
				formatting = {
					format = lspkind.cmp_format({
						mode = "symbol_text",
						maxwidth = 60,
						wllipsis_char = "...",
						show_labelDetails = true,
						before = function(entry, vim_item)
							-- Get the full snippet (and only keep first line)
							local word = entry:get_insert_text()
							if entry.completion_item.insertTextFormat == types.lsp.InsertTextFormat.Snippet then
								word = vim.lsp.util.parse_snippet(word)
							end
							word = str.oneline(word)

							-- concatenates the string
							-- local max = 50
							-- if string.len(word) >= max then
							-- 	local before = string.sub(word, 1, math.floor((max - 3) / 2))
							-- 	word = before .. "..."
							-- end

							if
								entry.completion_item.insertTextFormat == types.lsp.InsertTextFormat.Snippet
								and string.sub(vim_item.abbr, -1, -1) == "~"
							then
								word = word .. "~"
							end
							vim_item.abbr = word
							return vim_item
						end,
						menu = {
							buffer = "[Buffer]",
							nvim_lsp = "[LSP]",
							luasnip = "[LuaSnip]",
							nvim_lua = "[Lua]",
							path = "[path]",
							rg = "[RG]",
							cmp_git = "[Git]",
							nvim_lsp_signature_help = "[Help]",
							bufname = "[bufname]",
							otter = "[otter]",
						},
					}),
					fields = {
						cmp.ItemField.Abbr,
						cmp.ItemField.Kind,
						cmp.ItemField.Menu,
					},
				},
				mapping = cmp.mapping.preset.insert({
					["<C-d>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
					["<CR>"] = cmp.mapping({
						i = function(fallback)
							if cmp.visible() and cmp.get_active_entry() then
								cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
							else
								fallback()
							end
						end,
						s = cmp.mapping.confirm({ select = true }),
						c = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
					}),
					-- cmp.mapping(function(fallback)
					-- 	if cmp.visible() then
					-- 		if luasnip.expandable() then
					-- 			luasnip.expand()
					-- 		else
					-- 			cmp.confirm({
					-- 				behavior = cmp.ConfirmBehavior.Replace,
					-- 				select = true,
					-- 			})
					-- 		end
					-- 	else
					-- 		fallback()
					-- 	end
					-- end),
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.expand_or_jumpable() then
							luasnip.expand_or_jump()
						else
							fallback()
						end
					end, { "i", "s" }),
					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.locally_jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "otter" },
					{ name = "luasnip" }, -- For luasnip users.
					{ name = "cmp_git" }, -- For luasnip users.
					{ name = "nvim_lsp_signature_help" },
					{ name = "path" },
					{ name = "bufname" },
					{ name = "zsh" },
					{
						name = "rg",
						-- option = {
						-- 	additional_arguments = "--hidden",
						-- },
					},
					{
						name = "buffer-lines",
						option = {
							words = true,
							comments = false,
							line_numbers = true,
							line_number_separator = "|",
						},
					},
				}, {
					{
						name = "buffer",
						option = {
							keyword_pattern = [[\k\+]],
							get_bufnrs = function()
								return vim.api.nvim_list_bufs()
							end,
						},
					},
				}),
				sorting = {
					comparators = {
						compare.offset,
						compare.exact,
						compare.score,
						compare.recently_used,
						compare.locality,
						compare.kind,
						compare.sort_text,
						compare.length,
						compare.order,
					},
				},
			})

			cmp.event:on("config_done", cmp_autopairs.on_confirm_done())

			cmp.event:on(
				"confirm_done",
				cmp_autopairs.on_confirm_done({
					filetypes = {
						-- "*" is a alias to all filetypes
						["*"] = {
							["("] = {
								kind = {
									cmp.lsp.CompletionItemKind.Function,
									cmp.lsp.CompletionItemKind.Method,
								},
								handler = handlers["*"],
							},
						},
						lua = {
							["("] = {
								kind = {
									cmp.lsp.CompletionItemKind.Function,
									cmp.lsp.CompletionItemKind.Method,
								},
								---@param char string
								---@param item table item completion
								---@param bufnr number buffer number
								---@param rules table
								---@param commit_character table<string>
								handler = function(char, item, bufnr, rules, commit_character)
									-- Your handler function. Inspect with print(vim.inspect{char, item, bufnr, rules, commit_character})
								end,
							},
						},
						-- Disable for tex
						tex = false,
					},
				})
			)

			cmp.setup.filetype("gitcommit", {
				sources = cmp.config.sources({
					{ name = "git" },
				}, {
					{ name = "buffer" },
				}),
			})
			require("cmp_git").setup()
			cmp.setup.cmdline({ "/", "?" }, {
				view = {
					entries = { name = "wildmenu", separator = "|" },
				},
				mapping = cmp.mapping.preset.cmdline(),
				sources = {
					{ name = "buffer-lines" },
					{
						name = "buffer",
						option = { keyword_pattern = [[\k\+]] },
					},
				},
			})
			cmp.setup.cmdline(":", {
				mapping = cmp.mapping.preset.cmdline({
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
					["<CR>"] = cmp.mapping({
						i = function(fallback)
							if cmp.visible() and cmp.get_active_entry() then
								cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
							else
								fallback()
							end
						end,
						s = cmp.mapping.confirm({ select = true }),
						c = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
					}),
					-- cmp.mapping(function(fallback)
					-- 	if cmp.visible() then
					-- 		if luasnip.expandable() then
					-- 			luasnip.expand()
					-- 		else
					-- 			cmp.confirm({
					-- 				behavior = cmp.ConfirmBehavior.Replace,
					-- 				select = true,
					-- 			})
					-- 		end
					-- 	else
					-- 		fallback()
					-- 	end
					-- end),
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.expand_or_jumpable() then
							luasnip.expand_or_jump()
						else
							fallback()
						end
					end, { "i", "s" }),
					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.locally_jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),
				}),
				sources = cmp.config.sources({
					{ name = "path" },
				}, {
					{ name = "cmdline" },
				}),
				matching = { disallow_symbol_nonprefix_matching = false },
			})
			require("diaglist").init({
				debug = false,
				debounce_ms = 150,
			})
			-- gray
			vim.api.nvim_set_hl(0, "CmpItemAbbrDeprecated", { bg = "NONE", strikethrough = true, fg = "#808080" })
			-- blue
			vim.api.nvim_set_hl(0, "CmpItemAbbrMatch", { bg = "NONE", fg = "#569CD6" })
			vim.api.nvim_set_hl(0, "CmpItemAbbrMatchFuzzy", { link = "CmpIntemAbbrMatch" })
			-- light blue
			vim.api.nvim_set_hl(0, "CmpItemKindVariable", { bg = "NONE", fg = "#9CDCFE" })
			vim.api.nvim_set_hl(0, "CmpItemKindInterface", { link = "CmpItemKindVariable" })
			vim.api.nvim_set_hl(0, "CmpItemKindText", { link = "CmpItemKindVariable" })
			-- pink
			vim.api.nvim_set_hl(0, "CmpItemKindFunction", { bg = "NONE", fg = "#C586C0" })
			vim.api.nvim_set_hl(0, "CmpItemKindMethod", { link = "CmpItemKindFunction" })
			-- front
			vim.api.nvim_set_hl(0, "CmpItemKindKeyword", { bg = "NONE", fg = "#D4D4D4" })
			vim.api.nvim_set_hl(0, "CmpItemKindProperty", { link = "CmpItemKindKeyword" })
			vim.api.nvim_set_hl(0, "CmpItemKindUnit", { link = "CmpItemKindKeyword" })
		end,
	},
}
