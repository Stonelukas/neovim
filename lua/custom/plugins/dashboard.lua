return {
	{
		"nvimdev/dashboard-nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("dashboard").setup({
				theme = "hyper",
				config = {
					week_header = {
						enable = true,
					},
					shortcut = {
						{ desc = "󰊳 Update", group = "@property", action = "Lazy update", key = "u" },
						{
							icon = " ",
							icon_hl = "@variable",
							desc = "Files",
							group = "Label",
							action = "Telescope find_files",
							key = "f",
						},
						{
							desc = " Search",
							icon_hl = "@variable",
							group = "Label",
							action = "Telescope live_grep",
							key = "g",
						},
						{
							desc = " Workspace",
							group = "Number",
							action = "SessionLoad",
							-- action = "lua require('sessions').load('.nvim/session/home.stonelukas..config.nvim.session')",
							key = "w",
						},
						{
							desc = " Sessions",
							group = "Number",
							action = "Telescope persisted",
							key = "s",
						},
						{
							desc = " Recent",
							icon_hl = "@variable",
							group = "Label",
							action = "Telescope oldfiles",
							key = "r",
						},
					},
				},
			})
		end,
	},
}
