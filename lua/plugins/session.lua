return {
	{
		"stevearc/resession.nvim",
		opts = {},
		config = function()
			local resession = require("resession")
			resession.setup({
				autosave = {
					enabled = true,
					interval = 30,
					notify = false,
				},
				options = {
					"binary",
					"bufhidden",
					"buflisted",
					"cmdheight",
					"diff",
					"filetype",
					"modifiable",
					"previewwindow",
					"readonly",
					"scrollbind",
					"winfixheight",
					"winfixwidth",
				},
				dir = "session",
				load_detail = true,
				load_order = "modification_time",
				extensions = {
					quickfix = {},
                    scope = {},
				},
			})

			vim.keymap.set("n", "<leader>ss", resession.save, { desc = 'Save Current session' })
			vim.keymap.set("n", "<leader>sl", resession.load, { desc = 'load selected session' })
			vim.keymap.set("n", "<leader>sd", resession.delete, { desc = 'Delete sessions' })
		end,
	},
}
