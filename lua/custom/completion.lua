-- Load and initialize lspkind for better visual representation of completion items
local lspkind = require("lspkind")
lspkind.init({})

-- Load necessary modules for completion
local cmp = require("cmp")
local luasnip = require("luasnip")
local cmp_autopairs = require("nvim-autopairs.completion.cmp")
local handlers = require("nvim-autopairs.completion.handlers")

-- Lazy load snippets from VSCode and SnipMate
require("luasnip.loaders.from_vscode").lazy_load()
require("luasnip.loaders.from_vscode").lazy_load({ paths = vim.g.vscode_snippets_path or "" })
require("luasnip.loaders.from_snipmate").lazy_load()
require("luasnip.loaders.from_snipmate").lazy_load({ paths = vim.g.snipmate_snippets_path or "" })
require("luasnip.loaders.from_lua").lazy_load()
require("luasnip.loaders.from_lua").lazy_load({ paths = vim.g.lua_snippets_path or "" })

vim.api.nvim_create_autocmd("InsertLeave", {
	callback = function()
		if
			require("luasnip").session.current_nodes[vim.api.nvim_get_current_buf()]
			and not require("luasnip").session.jump_active
		then
			require("luasnip").unlink_current()
		end
	end,
})

-- Setup completion configuration
cmp.setup({
	-- Define the sources for completion
	sources = {
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
		{ name = "nvim_lua" },
		{ name = "codeium" },
		{ name = "nvim_lsp_signature_help" },
		{ name = "path", trigger_characters = { "/" } },
		{ name = "bufname", keyword_length = 5 },
		{ name = "cmp_git" },
		{ name = "zsh" },
		{
			name = "rg",
			keyword_length = 6,
			option = {
				additional_arguments = "--hidden",
			},
		},
		-- {
		-- 	name = "buffer-lines",
		-- 	option = {
		-- 		words = true,
		-- 		comments = false,
		-- 		line_numbers = false,
		-- 		line_number_separator = "|",
		-- 	},
		-- },
		{
			name = "buffer",
			priority = 1,
			option = {
				keyword_pattern = [[\k\+]],
				get_bufnrs = function()
					return vim.api.nvim_list_bufs()
				end,
			},
		},
	},
	-- Define key mappings for completion interactions
	mapping = cmp.mapping.preset.insert({
		["<C-b>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-e>"] = cmp.mapping.abort(),
		["<CR>"] = cmp.mapping(
			cmp.mapping.confirm({
				behaviour = cmp.ConfirmBehavior.insert,
				select = false,
			}),
			{ "i", "c" }
		),
		["<Tab>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
		["<S-Tab>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
	}),

	-- Configure the view and window behavior for completion
	view = {
		entries = { name = "custom", selection_order = "top_down" },
	},
	window = {
		completion = cmp.config.window.bordered({}),
		documentation = cmp.config.window.bordered(),
	},
	-- Define how completion items are formatted
	formatting = {
		expandable_indicator = true,
		fields = { "menu", "abbr", "kind" },
		format = lspkind.cmp_format({
			mode = "symbol_text",
			maxwidth = 80,
			wllipsis_char = "...",
			show_laelDetails = true,
			menu = {
				nvim_lsp = "[LSP]",
				luasnip = "[luaSnip]",
				nvim_lua = "[Lua]",
				codeium = "",
				path = "🖫",
				rg = "[RG]",
				cmp_git = "[Git]",
				nvim_lsp_signature_help = "[Help]",
				bufname = "[bufname]",
				buffer = "[Buffer]",
				zsh = "[ZSH]",
			},
		}),
	},

	-- Enable luasnip to handle snippet expasnion for nvim-cmp
	snippet = {
		expand = function(args)
			vim.snippet.expand(args.body)
		end,
	},
})

-- Register event handlers for auto-pairing on completion confirm
cmp.event:on("config_done", cmp_autopairs.on_confirm_done())

cmp.event:on(
	"confirm_done",
	cmp_autopairs.on_confirm_done({
		filetypes = {
			["*"] = {
				["("] = {
					kind = {
						cmp.lsp.CompletionItemKind.Function,
						cmp.lsp.CompletionItemKind.Method,
					},
					handler = handlers["*"],
				},
			},
		},
	})
)

-- Special completion setup for gitcommit filetype
cmp.setup.filetype("gitcommit", {
	sources = cmp.config.sources({
		{ name = "git" },
	}, {
		{ name = "buffer" },
	}),
})
require("cmp_git").setup()
-- Setup command line completion for search and replace
cmp.setup.cmdline({ "/", "?" }, {
	completion = cmp.config.window.bordered(),
	sources = {
		{ name = "buffer", option = { keyword_pattern = [[\k\+]] } },
		{ name = "cmp" },
	},
	preselect = "None",
	mapping = cmp.mapping.preset.cmdline({
		["<CR>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.insert,
			select = false,
		}),
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
})

-- Setup command line completion for command mode
cmp.setup.cmdline(":", {
	mapping = cmp.mapping.preset.cmdline({
		["<CR>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.insert,
			select = false,
		}),
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
})

-- Set highlighting for different completion item types
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
