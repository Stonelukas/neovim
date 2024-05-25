return {
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

		vim.o.termguicolors = true
		vim.o.background = "light"
		vim.cmd.colorscheme("catppuccin-mocha")
	end,
}
