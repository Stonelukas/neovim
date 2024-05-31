return {
	{
		"Exafunction/codeium.vim",
		event = "BufEnter",
		config = function()
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
}
