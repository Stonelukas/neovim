--   https://github.com/shellRaining/hlchunk.nvim
return {
	"shellRaining/hlchunk.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		require("hlchunk").setup({
			chunk = {
				enable = true,
				-- use_treesitter = true,
			},
			line_num = {
				enable = true,
				-- use_treesitter = true,
			},
			blank = {
				enable = true,
				-- use_treesitter = true,
				chars = {
					" ",
				},
				style = {
					{ bg = "#434437" },
					{ bg = "#2f4440" },
					{ bg = "#433054" },
					{ bg = "#284251" },
				},
			},
			indent = {
				enable = true,
				-- use_treesitter = true,
				chars = {
					"│",
					"¦",
					"┆",
					"┊",
				},
				style = {
					vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID("Whitespace")), "fg", "gui"),
				},
			},
		})
	end,
}
