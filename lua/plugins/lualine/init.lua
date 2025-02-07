return {
	{
		"nvim-lualine/lualine.nvim",
		enabled = true,
		cond = true,
		config = function()
			-- config
			require("plugins.lualine.config")
		end,
	},
}
