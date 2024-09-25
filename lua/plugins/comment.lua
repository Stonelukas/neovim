return {
	"numToStr/Comment.nvim",
	dependencies = {
		"joosepAlviste/nvim-ts-context-commentstring",
	},
	lazy = false,
	config = function()
		require("Comment").setup({
			pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
		})

		require("ts_context_commentstring").setup({
			enable_autocmd = false,
		})

		local get_option = vim.filetype.get_option
		vim.filetype.get_option = function(filetype, option)
			return option == "commentstring" and require("ts_context_commentstring.internal").calculate_commentstring()
				or get_option(filetype, option)
		end
	end,
}
