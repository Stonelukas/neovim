return {
	{
		"folke/persistence.nvim",
		event = "BufReadPre",
		opts = {
			dir = vim.fn.expand(vim.fn.stdpath("state") .. "/sessions/"), -- directory where session files are saved
			options = { "buffers", "curdir", "tabpages", "winsize", "help", "folds", "blank", "tabpages", "winpos" }, -- sessionoptions used for saving
			pre_save = nil, -- a function to call before saving the session
			post_save = nil, -- a function to call after saving the session
			save_empty = false, -- don't save if there are no open file buffers
			pre_load = nil, -- a function to call before loading the session
			post_load = nil, -- a function to call after loading the session
		},
		config = function()
			-- restore the session for the current directory
			vim.api.nvim_set_keymap("n", "<leader>qs", [[<cmd>lua require("persistence").load()<cr>]], {})

			-- restore the last session
			vim.api.nvim_set_keymap(
				"n",
				"<leader>ql",
				[[<cmd>lua require("persistence").load({ last = true })<cr>]],
				{}
			)

			-- stop Persistence => session won't be saved on exit
			vim.api.nvim_set_keymap("n", "<leader>qd", [[<cmd>lua require("persistence").stop()<cr>]], {})
		end,
	},
}
