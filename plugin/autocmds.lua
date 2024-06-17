-- Create a local alias for the function to create autocommand groups
local augroup = vim.api.nvim_create_augroup
-- Create a local alias for the function to create autocommands
local autocmd = vim.api.nvim_create_autocmd

-- Disable automatic commenting of new lines when entering a buffer
autocmd("BufEnter", {
	pattern = "",  -- Apply to all buffers
	command = "set fo-=c fo-=r fo-=o",  -- Remove 'c', 'r', and 'o' from 'formatoptions'
})

-- Create an autocommand for the 'User' event with pattern 'LuasnipPreExpand'
vim.api.nvim_create_autocmd("User", {
	pattern = "LuasnipPreExpand",
	callback = function()
		-- Get the snippet that is about to be expanded from the Luasnip session
		local snippet = require("luasnip").session.event_node
		-- Get the position in the buffer where the snippet will expand
		local expand_position = require("luasnip").session.event_args.expand_pos

		-- Print a formatted message to the command line showing which snippet is expanding and where
		print(
			string.format(
				"expanding snippet %s at %s:%s",
				table.concat(snippet:get_docstring(), "\n"),  -- `get_docstring` returns the documentation string of the snippet.
				expand_position[1],  -- Line number of the expansion position.
				expand_position[2]   -- Column number of the expansion position.
			)
		)
	end,
})
