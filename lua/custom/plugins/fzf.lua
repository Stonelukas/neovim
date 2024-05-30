return {
	{ "junegunn/fzf", build = "./install --all" },
	{
		"vijaymarupudi/nvim-fzf",
		config = function()
			require("custom.fzf")
		end,
	},
	{
		"vijaymarupudi/nvim-fzf-commands",
	},
	{
		"ibhagwan/fzf-lua",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			-- require("custom.fzf")
		end,
	},
}
