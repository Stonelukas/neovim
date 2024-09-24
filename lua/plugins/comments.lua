return {
	{
		"folke/todo-comments.nvim",
		opts = {},
		config = function()
			local comments = require("todo-comments")
			local map = vim.keymap.set
			local function opts(desc)
				return { desc = "" .. desc, noremap = true, silent = true, nowait = true }
			end

			comments.setup()

			map("n", "<leader>vn", function()
				comments.jump_next()
			end, opts("Next todo comment"))
			map("n", "<leader>vp", function()
				comments.jump_prev()
			end, opts("Previous todo comment"))
		end,
	},
}
