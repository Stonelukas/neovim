return {
	"chrisgrieser/nvim-scissors",
	dependencies = "nvim-telescope/telescope.nvim",
	opts = {
		snippetDir = { vim.fn.stdpath("config") .. "/snippets" },
		telescope = {
			-- By default, the query only searches snippet prefixes. Set this to
			-- `true` to also search the body of the snippets.
			alsoSearchSnippetBody = true,

			-- accepts the common telescope picker config
			opts = {
				layout_strategies = "horizontal",
				layout_config = {
					horizontal = { width = 0.9 },
					preview_width = 0.6,
				},
			},
		},
		jsonFormatter = "jq",
	},
	config = function()
		vim.keymap.set("n", "<leader>se", function()
			require("scissors").editSnippet()
		end, { desc = "Snippet: Edit" })
		vim.keymap.set({ "n", "x" }, "<leader>sa", function()
			require("scissors").addNewSnippet()
		end, { desc = "Snippet: Add" })
	end,
}
