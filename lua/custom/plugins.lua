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
	{
		"tpope/vim-speeddating",
		config = function() end,
		vim.keymap.set("n", "<leader>dd", "<Plug>SpeedDatingdate"),
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
}
