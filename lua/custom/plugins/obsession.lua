return {
	{
		"tpope/vim-obsession",
		config = function()
			vim.keymap.set("n", "<leader>os", ":Obsess<cr>")
			vim.keymap.set("n", "<leader>ob", ":Obsess!<cr>")
		end,
	},
}
