return {
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
	{
		"johmsalas/text-case.nvim",
		config = function()
			require("textcase").setup({})

			vim.api.nvim_set_keymap("n", "ga.", "<cmd>TextCaseOpenTelescope<CR>", { desc = "Telescope" })
			vim.api.nvim_set_keymap("v", "ga.", "<cmd>TextCaseOpenTelescope<CR>", { desc = "Telescope" })
			vim.api.nvim_set_keymap(
				"n",
				"gaa",
				"<cmd>TextCaseOpenTelescopeQuickChange<CR>",
				{ desc = "Telescope Quick Change" }
			)
			vim.api.nvim_set_keymap(
				"n",
				"gai",
				"<cmd>TextCaseOpenTelescopeLSPChange<CR>",
				{ desc = "Telescope LSP Change" }
			)
		end,
	},
	{
		"danielhp95/tmpclone-nvim",
		dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
		config = function()
			require("tmpclone").setup({
				datadir = vim.fn.stdpath("data") .. "/tmpclone-data",
			})
		end,
	},
	{
		"rainbowhxch/accelerated-jk.nvim",
		config = function()
			require("accelerated-jk").setup()

			vim.api.nvim_set_keymap("n", "j", "<Plug>(accelerated_jk_gj)", {})
			vim.api.nvim_set_keymap("n", "k", "<Plug>(accelerated_jk_gk)", {})
		end,
	},
	{
		"mattn/calendar-vim",
		config = function() end,
	},
	{
		"ziontee113/icon-picker.nvim",
		config = function()
			require("icon-picker").setup({ disable_legacy_commands = true })

			local opts = { noremap = true, silent = true }

			vim.keymap.set("n", "<Leader><Leader>i", "<cmd>IconPickerNormal<cr>", opts)
			vim.keymap.set("n", "<Leader><Leader>y", "<cmd>IconPickerYank<cr>", opts) --> Yank the selected icon into register
			vim.keymap.set("i", "<C-i>", "<cmd>IconPickerInsert<cr>", opts)
		end,
	},
	{
		"lukas-reineke/virt-column.nvim", -- Use characters in the color column
		opts = {
			char = "│",
			highlight = "VirtColumn",
		},
	},
	{
		"AckslD/nvim-neoclip.lua",
		config = function()
			require("neoclip").setup()
		end,
	},
	{
		"tjdevries/train.nvim",
	},
	{
		"lukas-reineke/headlines.nvim",
		dependencies = "nvim-treesitter/nvim-treesitter",
		config = function()
			require("headlines").setup({
				markdown = {
					headline_highlights = {
						"Headline1",
						"Headline2",
						"Headline3",
						"Headline4",
						"Headline5",
						"Headline6",
					},
					codeblock_highlight = "Codeblock",
					dash_highlight = "Dash",
					quote_highlight = "Quote",
				},
			})
		end, -- or `opts = {}`
	},
	{
		"ggandor/leap.nvim",
		config = function()
			-- require('leap').create_default_mappings()

			-- Define equivalence classes for brackets and quotes, in addition to
			-- the default whitespace group.
			require("leap").opts.equivalence_classes = { " \t\r\n", "([{", ")]}", "'\"`" }

			-- Override some old defaults - use backspace instead of tab (see issue #165).
			require("leap").opts.special_keys.prev_target = "<backspace>"
			require("leap").opts.special_keys.prev_group = "<backspace>"

			-- Use the traversal keys to repeat the previous motion without explicitly
			-- invoking Leap.
			require("leap.user").set_repeat_keys("<enter>", "<backspace>")

			-- Hide the (real) cursor when leaping, and restore it afterwards.
			vim.api.nvim_create_autocmd("User", {
				pattern = "LeapEnter",
				callback = function()
					vim.cmd.hi("Cursor", "blend=100")
					vim.opt.guicursor:append({ "a:Cursor/lCursor" })
				end,
			})
			vim.api.nvim_create_autocmd("User", {
				pattern = "LeapLeave",
				callback = function()
					vim.cmd.hi("Cursor", "blend=0")
					vim.opt.guicursor:remove({ "a:Cursor/lCursor" })
				end,
			})
		end,
	},
	{
		"ggandor/leap-spooky.nvim",
		config = function()
			require("leap-spooky").setup({
				-- Additional text objects, to be merged with the default ones.
				-- E.g.: {'iq', 'aq'}
				extra_text_objects = nil,
				-- Mappings will be generated corresponding to all native text objects,
				-- like: (ir|ar|iR|aR|im|am|iM|aM){obj}.
				-- Special line objects will also be added, by repeating the affixes.
				-- E.g. `yrr<leap>` and `ymm<leap>` will yank a line in the current
				-- window.
				affixes = {
					-- The cursor moves to the targeted object, and stays there.
					magnetic = { window = "m", cross_window = "M" },
					-- The operation is executed seemingly remotely (the cursor boomerangs
					-- back afterwards).
					remote = { window = "r", cross_window = "R" },
				},
				-- Defines text objects like `riw`, `raw`, etc., instead of
				-- targets.vim-style `irw`, `arw`. (Note: prefix is forced if a custom
				-- text object does not start with "a" or "i".)
				prefix = false,
				-- The yanked text will automatically be pasted at the cursor position
				-- if the unnamed register is in use.
				paste_on_remote_yank = false,
			})
		end,
	},
	{
		"chrisgrieser/nvim-spider",
		dependencies = {
			"theHamsta/nvim_rocks",
			build = "pipx install --user hererocks && python3 -mhererocks . -j2.1.0-beta3 -r3.0.0 && cp nvim_rocks.lua lua",
			config = function()
				require("nvim_rocks").ensure_installed("luautf8")
			end,
		},
		lazy = true,
		config = function()
			vim.keymap.set({ "n", "o", "x" }, "w", "<cmd>lua require('spider').motion('w')<CR>", { desc = "Spider-w" })
			vim.keymap.set({ "n", "o", "x" }, "e", "<cmd>lua require('spider').motion('e')<CR>", { desc = "Spider-e" })
			vim.keymap.set({ "n", "o", "x" }, "b", "<cmd>lua require('spider').motion('b')<CR>", { desc = "Spider-b" })
		end,
	},
	{
		"nvim-pack/nvim-spectre",
		config = function()
			vim.keymap.set("n", "<leader>S", '<cmd>lua require("spectre").toggle()<CR>', {
				desc = "Toggle Spectre",
			})
			vim.keymap.set("n", "<leader>sW", '<cmd>lua require("spectre").open_visual({select_word=true})<CR>', {
				desc = "Search current word",
			})
			vim.keymap.set("v", "<leader>sW", '<esc><cmd>lua require("spectre").open_visual()<CR>', {
				desc = "Search current word",
			})
			vim.keymap.set("n", "<leader>sP", '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>', {
				desc = "Search on current file",
			})
		end,
	},
	{
		"voldikss/vim-floaterm",
		config = function()
			vim.g.floaterm_autoclose = 1
		end,
	},
	{
		"voldikss/vim-browser-search",
		config = function()
			vim.cmd([[
            nmap <silent> <leader>Os <Plug>SearchNormal
            vmap <silent> <leader>Os <Plug>SearchVisual
            ]])
		end,
	},
}
