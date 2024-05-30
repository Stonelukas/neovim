local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Don't auto commenting new lines
autocmd("BufEnter", {
	pattern = "",
	command = "set fo-=c fo-=r fo-=o",
})

vim.api.nvim_create_autocmd("User", {
	pattern = "LuasnipPreExpand",
	callback = function()
		-- get event-parameters from `session`.
		local snippet = require("luasnip").session.event_node
		local expand_position = require("luasnip").session.event_args.expand_pos

		print(
			string.format(
				"expanding snippet %s at %s:%s",
				table.concat(snippet:get_docstring(), "\n"),
				expand_position[1],
				expand_position[2]
			)
		)
	end,
})
