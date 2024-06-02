return {
	{
		"catppuccin/nvim",
		lazy = false,
		name = "catppuccin",
		priority = 1000,
		config = function()
			require("catppuccin").setup({
				flavour = "mocha",
				transparent_background = false,
				styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
					comments = { "italic" }, -- Change the style of comments
				},
			})
		end,
	},
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		opts = {},
		config = function()
			require("tokyonight").setup({
				style = "moon",
				light_style = "day",
				transparent = true,
				terminal_colors = true,
				styles = {
					comments = { italic = true },
					keywords = { italic = true },
					sidebars = "dark",
					floats = "dark",
				},
				sidebars = { "qf", "help" },
				require("tokyonight").setup({
					on_highlights = function(hl, c)
						local prompt = "#2d3149"
						hl.TelescopeNormal = {
							bg = c.bg_dark,
							fg = c.fg_dark,
						}
						hl.TelescopeBorder = {
							bg = c.bg_dark,
							fg = c.bg_dark,
						}
						hl.TelescopePromptNormal = {
							bg = prompt,
						}
						hl.TelescopePromptBorder = {
							bg = prompt,
							fg = prompt,
						}
						hl.TelescopePromptTitle = {
							bg = prompt,
							fg = prompt,
						}
						hl.TelescopePreviewTitle = {
							bg = c.bg_dark,
							fg = c.bg_dark,
						}
						hl.TelescopeResultsTitle = {
							bg = c.bg_dark,
							fg = c.bg_dark,
						}
					end,
				}),
			})
			vim.o.background = "dark"
			vim.cmd([[colorscheme tokyonight]])
		end,
	},
	{},
}
