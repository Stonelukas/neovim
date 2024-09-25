return {
	{
		"nvim-lualine/lualine.nvim",
		enabled = true,
		config = function()
			-- config
			require("plugins.lualine.config")
		end,
	},
}
