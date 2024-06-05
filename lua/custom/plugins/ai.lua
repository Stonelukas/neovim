return {
	{
		"Exafunction/codeium.vim",
		event = "BufEnter",
		config = function()
			require("codeium").setup({
				enable_chat = true,
			})

			vim.keymap.set("i", "<A-#>", function()
				return vim.fn["codeium#Accept"]()
			end, { expr = true })

			vim.keymap.set("i", "<A-,>", function()
				return vim.fn["codeium#CycleCompletions"](1)
			end, { expr = true })

			vim.keymap.set("i", "<A-.>", function()
				return vim.fn["codeium#CycleCompletions"](-1)
			end, { expr = true })

			vim.keymap.set("i", "<c-x>", function()
				return vim.fn["codeium#Clear"]()
			end, { expr = true })
		end,
	},
	{
		"Exafunction/codeium.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"hrsh7th/nvim-cmp",
		},
		config = function()
			require("codeium").setup({})
		end,
	},
}
