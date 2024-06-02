return {
	{
		"echasnovski/mini.nvim",
		-- version = false,
		config = function()
			-- Better Around/Inside textobjects
			--
			-- Examples:
			--  - va)  - [V]isually select [A]round [)]parenthen
			--  - yinq - [Y]ank [I]nside [N]ext [']quote
			--  - ci'  - [C]hange [I]nside [']quote
			require("mini.ai").setup({ n_lines = 500 })
			-- Add/delete/replace surroundings (brackets, quotes, etc.)
			--
			-- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
			-- - sd'   - [S]urround [D]elete [']quotes
			-- - sr)'  - [S]urround [R]eplace [)] [']
			require("mini.surround").setup()
		end,
	},
	{
		"chaoren/vim-wordmotion",
	},
	{
		"anuvyklack/vim-smartword",
	},
	{
		"mbbill/undotree",
		config = function()
			vim.keymap.set("n", "<leader>u", "<cmd>UndotreeShow<cr>", { desc = "Show undotree" })
		end,
	},
	{
		"jlanzarotta/bufexplorer",
	},
	{
		"tpope/vim-surround",
		config = function()
			vim.g.surround_no_maKppings = 1
		end,
	},
	{
		"tpope/vim-repeat",
		config = function()
			vim.keymap.set("n", "gq", "gqap")
		end,
	},
	-- {
	-- 	---- Increment numbers ----
	-- 	"tpope/vim-speeddating",
	-- 	config = function() end,
	-- 	vim.keymap.set("n", "<leader>dd", "<Plug>SpeedDatingdate"),
	-- },
	{
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
	},
	{
		"glacambre/firenvim",
		lazy = not vim.g.started_by_firenvim,
		build = function()
			vim.fn["firenvim#install"](0)
		end,
		config = function()
			vim.g.firenvim_config.localSettings[".*"] = { cmdline = "firenvim" }
		end,
	},
	{
		"tpope/vim-unimpaired",
	},
	{
		"svermeulen/vim-easyclip",
		config = function()
			vim.g.EasyClipUseSubstituteDefaults = 1
			vim.g.EasyClipAlwaysMoveCursorToEndOfPaste = 1
			vim.g.EasyClipAutoFormat = 1
			vim.keymap.set("n", "<leader>yf", "<Cmd>call EasyClip#Yank(expand('%'))<CR>")
			vim.keymap.set("n", "<leader>cf", "<plug>EasyClipToggleFormattedPaste")
			vim.keymap.set("n", "<leader>cc", "<Plug>EasyClipPasteAlternative")
			vim.keymap.set("n", "<leader>ch", "<Plug>EasyClipPasteBefore")
		end,
	},
	{
		"svermeulen/vim-subversive",
		config = function()
			vim.keymap.set("n", "s", "<plug>SubversiveSubstitute")
			vim.keymap.set("n", "S", "<plug>SubversiveSubstituteToEndOfLine")
			vim.cmd([[ onoremap ie :exec "normal! ggVG"<cr> ]])
			vim.cmd([[ onoremap iv :exec "normal! HVL"<cr> ]])
			vim.keymap.set({ "n", "x" }, "<leader>s", "<plug>(SubversiveSubstituteRange)")
		end,
	},
	{
		"glts/vim-magnum",
	},
	{
		"glts/vim-radical",
		config = function() end,
	},
	{
		"xiyaowong/transparent.nvim",
		config = function()
			require("transparent").setup({
				extra_groups = {
					"NvimTreeNormal",
					"NormalNC",
					"LspInfoFloat",
					"TelescopeNormal",
					"TelescopeBorder",
					"TelescopePromptBorder",
					"TelescopeResultsBorder",
					"TelescopePreviewBorder",
					"TelescopePromptNormal",
					"TelescopeResultsNormal",
					"TelescopePreviewNormal",
					"BufferLineFill",
					"BufferLineBackground",
					"BufferLineCurrent",
					"BufferLineCurrentVisible",
					"BufferLineBufferSelected",
					"BufferLineFill",
					"Pmenu",
					"PmenuSel",
					"PmenuSbar",
					"PmenuThumb",
					"GitSignsAdd",
					"GitSignsChange",
					"GitSignsDelete",
					"GitSignsAddLn",
					"GitSignsChangeLn",
					"GitSignsDeleteLn",
					"DiffAdd",
					"DiffChange",
					"DiffDelete",
					"DiffText",
					"DiffAdded",
					"DiffFile",
					"DiffNewFile",
					"DiffLine",
					"DiffRemoved",
				},
			})
			require("tokyonight").setup({ transparent = vim.g.transparent_enabled })
		end,
	},
	{
		"Eandrju/cellular-automaton.nvim",
	},
	{
		"booperlv/nvim-gomove",
		config = function()
			require("gomove").setup()
		end,
	},
	{
		"ethanholz/nvim-lastplace",
		config = function()
			-- 	require("nvim-lastplace").setup({
			-- 		lastplace_ignore_buftype = { "quickfix", "nofile", "help" },
			-- 		lastplace_ignore_filetype = { "gitcommit", "gitrebase", "svn", "hgcommit" },
			-- 		lastplace_open_folds = true,
			-- 	})
		end,
	},
	{
		"andymass/vim-matchup",
		config = function()
			vim.g.matchup_matchparen_offscreen = { method = "popup" }
			vim.g.matchup_matchparen_deferred = 1
			vim.g.matchup_surround_enabled = 1
			vim.g.matchup_matchparen_hi_surround_always = 1 -- Show surrounding delimiters
			vim.g.matchup_transmute_enabled = 1
			vim.g.matchup_matchparen_enabled = 1
		end,
	},
}
