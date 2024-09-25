return {
	-- {
	-- },
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
		end,
	},
	{
		"rmehri01/onenord.nvim",
		config = function()
			require("onenord").setup({
				theme = "dark", -- "dark" or "light". Alternatively, remove the option and set vim.o.background instead
				borders = true, -- Split window borders
				fade_nc = false, -- Fade non-current windows, making them more distinguishable
				-- Style that is applied to various groups: see `highlight-args` for options
				styles = {
					comments = "NONE",
					strings = "NONE",
					keywords = "NONE",
					functions = "NONE",
					variables = "NONE",
					diagnostics = "underline",
				},
				disable = {
					background = false, -- Disable setting the background color
					float_background = false, -- Disable setting the background color for floating windows
					cursorline = false, -- Disable the cursorline
					eob_lines = true, -- Hide the end-of-buffer lines
				},
				-- Inverse highlight for different groups
				inverse = {
					match_paren = false,
				},
				custom_highlights = {}, -- Overwrite default highlight groups
				custom_colors = {}, -- Overwrite default colors
			})
		end,
	},
	{
		"shaunsingh/nord.nvim",
		config = function()
			-- Example config in lua
			vim.g.nord_contrast = false
			vim.g.nord_borders = true
			vim.g.nord_disable_background = false
			vim.g.nord_italic = true
			vim.g.nord_uniform_diff_background = true
			vim.g.nord_bold = false

			-- Load the colorscheme
			require("nord").set()
		end,
	},
}
