return {
	{
		"stevearc/aerial.nvim",

		opts = {},
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			require("aerial").setup({
				layout = {
					placement = "edge",
				},
				atach_mode = "global",
				-- optionally use on_attach to set keymaps when aerial has attached to a buffer
				on_attach = function(bufnr)
					-- Jump forwards/backwards with '{' and '}'
					vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr })
					vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr })
				end,
				highlight_on_hover = true,
				autojump = true,
				manage_folds = false,
				link_folds_to_tree = true,
				show_guides = true,
				nav = {
					autojump = true,
					preview = true,
				},
				treesitter = {
					experimental_selection_range = true,
				},
			})
			-- You probably also want to set a keymap to toggle aerial
			vim.keymap.set("n", "<leader>at", "<cmd>AerialToggle!<CR>")
		end,
	},
}
