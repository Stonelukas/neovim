return {
	{
		"folke/styler.nvim",
		config = function()
			require("styler").setup({
				themes = {
					help = { colorscheme = "catppuccin-mocha", background = "dark" },
				},
			})
		end,
	},
}
