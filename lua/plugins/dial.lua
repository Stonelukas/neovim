return {
	"monaqa/dial.nvim",

	config = function()
		local augend = require("dial.augend")
		require("dial.config").augends:register_group({
			default = {
				augend.integer.alias.decimal,
				augend.integer.alias.decimal_int,
				augend.integer.alias.hex,
				augend.integer.alias.octal,
				augend.constant.alias.bool,
				augend.constant.alias.alpha,
				augend.constant.alias.Alpha,
				augend.semver.alias.semver,
				augend.paren.alias.quote,
				augend.paren.alias.brackets,
				augend.paren.alias.lua_str_literal,
				augend.constant.new({
					elements = { "True", "Fasle" },
					word = true,
					cyclic = true,
				}),
				augend.paren.new({
					patterns = {
						{ "(", ")" },
						{ "[", "]" },
						{ "{", "}" },
						{ "(", ")" },
						{ "'", "'" },
						{ '"', '"' },
						{ "'", "'" },
					},
					nested = true,
					cyclic = false,
				}),
				augend.date.alias["%H:%M:%S"],
				augend.date.alias["%H:%M"],
				augend.date.alias["%d/%m/%Y"],
				augend.date.alias["%d/%m/%y"],
				augend.date.alias["%d.%m.%Y"],
				augend.date.alias["%d.%m.%y"],
				augend.date.alias["%d.%m."],
				augend.date.alias["%-d.%-m."],
				augend.constant.alias.de_weekday,
				augend.constant.alias.de_weekday_full,
				augend.date.new({
					pattern = "%d-%m-%Y",
					default_kind = "day",
					only_valid = true,
				}),
				augend.date.new({
					pattern = "%d-%m-%y",
					default_kind = "day",
					only_valid = true,
				}),
				augend.date.new({
					pattern = "%d, %b %Y",
					default_kind = "day",
					only_valid = true,
				}),
				augend.date.new({
					pattern = "%d, %b %Y",
					default_kind = "day",
					only_valid = true,
				}),
			},
		})

		vim.keymap.set("n", "+", function()
			require("dial.map").manipulate("increment", "normal")
		end)
		vim.keymap.set("n", "-", function()
			require("dial.map").manipulate("decrement", "normal")
		end)
		vim.keymap.set("n", "g+", function()
			require("dial.map").manipulate("increment", "gnormal")
		end)
		vim.keymap.set("n", "g-", function()
			require("dial.map").manipulate("decrement", "gnormal")
		end)
		vim.keymap.set("v", "+", function()
			require("dial.map").manipulate("increment", "visual")
		end)
		vim.keymap.set("v", "-", function()
			require("dial.map").manipulate("decrement", "visual")
		end)
		vim.keymap.set("v", "g+", function()
			require("dial.map").manipulate("increment", "gvisual")
		end)
		vim.keymap.set("v", "g-", function()
			require("dial.map").manipulate("decrement", "gvisual")
		end)
	end,
}
