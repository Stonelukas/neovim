return {
	{
		"nacro90/numb.nvim",
		config = function()
			require("numb").setup()
		end,
	},
	-- TODO: overlook
	{
		"chaoren/vim-wordmotion",
	},
	{
		"anuvyklack/vim-smartword",
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
		config = function()
			require("tmpclone").setup({
				datadir = vim.fn.stdpath("data") .. "/tmpclone-data",
			})
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
	{
		"jinh0/eyeliner.nvim",
		config = function()
			require("eyeliner").setup({
				highlight_on_key = true,
				dim = true,
			})
		end,
	},
	{
		"is0n/jaq-nvim",
		config = function()
			require("jaq-nvim").setup({
				cmds = {
					-- Uses vim commands
					internal = {
						lua = "source %",
						vim = "source %",
					},

					-- Uses shell commands
					external = {
						markdown = "glow %",
						bash = "bash %",
						zsh = "zsh %",
						javascript = "pnpm dev",
						typescript = "pnpm dev",
						jsx = "pnpm dev",
						tsx = "pnpm dev",
						rust = "cargo run",
						python = "python3 %",
						go = "go run %",
						sh = "sh %",
					},
					default = "term",
				},

				behavior = {
					-- Default type
					default = "terminal",

					-- Start in insert mode
					startinsert = false,

					-- Use `wincmd p` on startup
					wincmd = false,

					-- Auto-save files
					autosave = true,
				},

				ui = {
					float = {
						-- See ':h nvim_open_win'
						border = "rounded",

						-- See ':h winhl'
						winhl = "Normal",
						borderhl = "FloatBorder",

						-- See ':h winblend'
						winblend = 0,

						-- Num from `0-1` for measurements
						height = 0.8,
						width = 0.8,
						x = 0.5,
						y = 0.5,
					},

					terminal = {
						-- Window position
						position = "bot",

						-- Window size
						size = 14,

						-- Disable line numbers
						line_no = false,
					},

					quickfix = {
						-- Window position
						position = "bot",

						-- Window size
						size = 10,
					},
				},
			})
		end,
	},
	{
		"mawkler/modicator.nvim",
		dependencies = {
			"folke/tokyonight.nvim",
			"catppuccin/nvim",
			"rmehri01/onenord.nvim",
			"shaunsingh/nord.nvim",
		},
		opts = {
			show_warnings = true,
		},
	},
	{
		"chrisgrieser/nvim-spider",
		lazy = true,
		keys = {
			{
				"w",
				"<cmd>lua require('spider').motion('w')<CR>",
				mode = { "o", "x", "n" },
			},
			{
				"e",
				"<cmd>lua require('spider').motion('e')<CR>",
				mode = { "o", "x", "n" },
			},
			{
				"b",
				"<cmd>lua require('spider').motion('b')<CR>",
				mode = { "o", "x", "n" },
			},
			{
				"ge",
				"<cmd>lua require('spider').motion('ge')<CR>",
				mode = { "o", "x", "n" },
			},
		},
	},
	{
		"00sapo/visual.nvim",
		event = "VeryLazy",
	},
}
