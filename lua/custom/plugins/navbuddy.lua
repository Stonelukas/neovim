return {
	{
		"SmiteshP/nvim-navbuddy",
		dependencies = {
			"neovim/nvim-lspconfig",
			"SmiteshP/nvim-navic",
			"MunifTanjim/nui.nvim",
		},
		lazy = false, -- Need to set this up early so it can attach to LSP clients
		config = function()
			local navbuddy = require("nvim-navbuddy")
			local actions = require("nvim-navbuddy.actions")

			navbuddy.setup({
				window = {
					border = "rounded",
					size = "80%",
					position = "50%",
					sections = {
						right = {
							preview = "always",
						},
					},
				},
				lsp = {
					auto_attach = true,
				},
			})

			vim.keymap.set("n", "<leader>v", navbuddy.open, {})
		end,
	},
	{
		"SmiteshP/nvim-navic",
		dependencies = "neovim/nvim-lspconfig",
		config = function()
			local navic = require("nvim-navic")
			navic.setup({
				icons = {
					File = " ",
					Module = " ",
					Namespace = " ",
					Package = " ",
					Class = " ",
					Method = " ",
					Property = " ",
					Field = " ",
					Constructor = " ",
					Enum = " ",
					Interface = " ",
					Function = " ",
					Variable = " ",
					Constant = " ",
					String = " ",
					Number = " ",
					Boolean = " ",
					Array = " ",
					Object = " ",
					Key = " ",
					Null = " ",
					EnumMember = " ",
					Struct = " ",
					Event = " ",
					Operator = " ",
					TypeParameter = " ",
				},
				lsp = {
					auto_attach = true,
					preference = nil,
				},
				highlight = true,
				separator = " > ",
				depth_limit = 0,
				depth_limit_indicator = "..",
				safe_output = true,
				lazy_update_context = false,
				click = true,
				format_text = function(text)
					return text
				end,
			})
		end,
	},
}
