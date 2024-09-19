return {
	"Acksld/nvim-neoclip.lua",
	priority = 900,
	dependencies = {
		{ "kkharji/sqlite.lua", module = "sqlite" },
		"nvim-telescope/telescope.nvim",
	},
	config = function()
		local function is_whitespace(line)
			return vim.fn.match(line, [[^\s*$]]) ~= -1
		end

		local function all(tbl, check)
			for _, entry in ipairs(tbl) do
				if not check(entry) then
					return false
				end
			end
			return true
		end

		require("neoclip").setup({
			enable_persistent_history = true,
			default_registers = { '"', "+", "*" },
			preview = true,
			content_spec_column = false,
			on_select = {
				close_telescope = false,
			},
			filter = function(data)
				return not all(data.event.regcontents, is_whitespace)
			end,
			keys = {
				telescope = {
					n = {
						custom = {},
					},
				},
			},
		})
	end,
}
