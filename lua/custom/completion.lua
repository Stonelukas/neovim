vim.opt.completeopt = { "menu", "menuone", "noselect", "preview" }
vim.opt.shortmess:append("c")

local lspkind = require("lspkind")
lspkind.init({})

local cmp = require("cmp")
local luasnip = require("luasnip")
local cmp_autopairs = require("nvim-autopairs.completion.cmp")
local handlers = require("nvim-autopairs.completion.handlers")

require("luasnip.loaders.from_vscode").lazy_load()
require("luasnip.loaders.from_snipmate").lazy_load()

cmp.setup({
	sources = {
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
		{ name = "nvim_lsp_signature_help" },
		{ name = "path" },
		{ name = "bufname" },
		{ name = "cmp_git" },
		{ name = "zsh" },
		{
			name = "rg",
			option = {
				additional_arguments = "--hidden",
			},
		},
		{
			name = "buffer-lines",
			option = {
				words = true,
				comments = false,
				line_numbers = false,
				line_number_separator = "|",
			},
		},
		{
			name = "buffer",
			option = {
				keyword_pattern = [[\k\+]],
				get_bufnrs = function()
					return vim.api.nvim_list_bufs()
				end,
			},
		},
	},
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

	view = {
		entries = { name = "custom", selection_order = "top_down" },
	},
	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},
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

cmp.setup.filetype("gitcommit", {
	sources = cmp.config.sources({
		{ name = "git" },
	}, {
		{ name = "buffer" },
	}),
})
require("cmp_git").setup()
-- cmp.setup.cmdline({ "/", "?" }, {
-- 	view = {
-- 		entries = { name = "wildmenu", separator = "|" },
-- 	},
-- 	mapping = cmp.mapping.preset.cmdline(),
-- 	sources = {
-- 		{ name = "buffer-lines" },
-- 		{
-- 			name = "buffer",
-- 			option = { keyword_pattern = [[\k\+]] },
-- 		},
-- 	},
-- })
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
		{ name = "nvim_lsp" },
	}, {
		{ name = "cmdline" },
	}),
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
