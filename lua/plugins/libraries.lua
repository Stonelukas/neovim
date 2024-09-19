return {
	{
		"miversen33/netman.nvim",
		opts = {},
		config = true,
	},
	{
		"stevearc/dressing.nvim",
		priority = 1000,
		config = function()
			require("dressing").setup({
				prompt_align = "center",
				default_prompt = "> ",
				relative = "editor",
				prefer_width = 50,
				select = {
					get_config = function(opts)
						if opts.kind == "codeaction" then
							return {
								backend = "nui",
								nui = {
									relative = "cursor",
									max_width = 40,
								},
							}
						end
					end,
				},
			})
		end,
	},
	{ "nvim-lua/plenary.nvim" },
	{ "nvim-tree/nvim-web-devicons" },
	{ "muniftanjim/nui.nvim" },
	{ "kkharji/sqlite.lua", module = "sqlite" },
	{ "nvim-lua/popup.nvim" },
}
