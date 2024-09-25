return {
	{
		"s1n7ax/nvim-window-picker",
		version = "2.*",
		config = function()
			require("window-picker").setup({
				filter_rules = {
					include_current_win = false,
					autoselect_one = true,
					-- filter using buffer options
					bo = {
						-- if the file type is one of the following, the window will be ignored
						filetype = { "neotree", "neo-tree-popup", "notify" },
						-- if the buffer type is one of the following, the window will be ignored
						buftype = { "terminal", "quickfix" },
					},
				},
			})
		end,
	},
	{
		"sindrets/winshift.nvim",
		config = function()
			require("winshift").setup({
				highlight_moving_win = true, -- Highlight the window being moved
				focused_hl_group = "Visual", -- The highlight group used for the moving window
				moving_win_options = {
					-- These are local options applied to the moving window while it's
					-- being moved. They are unset when you leave Win-Move mode.
					wrap = false,
					cursorline = false,
					cursorcolumn = false,
					colorcolumn = "",
				},
				keymaps = {
					disable_defaults = false, -- Disable the default keymaps
				},
				---A function that should prompt the user to select a window.
				---
				---The window picker is used to select a window while swapping windows with
				---`:WinShift swap`.
				---@return integer? winid # Either the selected window ID, or `nil` to
				---   indicate that the user cancelled / gave an invalid selection.
				window_picker = function()
					return require("winshift.lib").pick_window({
						-- A string of chars used as identifiers by the window picker.
						picker_chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
						filter_rules = {
							-- This table allows you to indicate to the window picker that a window
							-- should be ignored if its buffer matches any of the following criteria.
							cur_win = true, -- Filter out the current window
							floats = true, -- Filter out floating windows
							filetype = {}, -- List of ignored file types
							buftype = {}, -- List of ignored buftypes
							bufname = {}, -- List of vim regex patterns matching ignored buffer names
						},
						---A function used to filter the list of selectable windows.
						---@param winids integer[] # The list of selectable window IDs.
						---@return integer[] filtered # The filtered list of window IDs.
						filter_func = nil,
					})
				end,
			})
		end,
	},
	{
		"mrjones2014/smart-splits.nvim",
		config = function()
			require("smart-splits").setup({
				ignored_filetypes = { "neo-tree" },
				resize_mode = {
					hooks = {
						on_leave = require("bufresize").register,
					},
				},
			})
		end,
	},
	{
		"kwkarlwang/bufresize.nvim",
		config = function()
			local function opts(desc)
				return { desc = "" .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
			end
			require("bufresize").setup({
				register = {
					keys = {
						{ "n", "<leader>w<", "20<C-w><", opts("Decrease width") },
						{ "n", "<leader>w>", "20<C-w>>", opts("Increase width") },
						{ "n", "<leader>w+", "2<C-w>+", opts("Increase height") },
						{ "n", "<leader>w-", "2<C-w>-", opts("Increase height") },
						{ "n", "<leader>w_", "<C-w>_", opts("Increase height to max") },
						{ "n", "<leader>w=", "<C-w>=", opts("Equal height and width") },
						{ "n", "<leader>w|", "<C-w>|", opts("Increase width to max") },
						{ "n", "<leader>wO", "<C-w>|<C-w>_", opts("Increase width and hight to max") },
					},
					trigger_events = { "BufWinEnter", "WinEnter" },
				},
				resize = {
					keys = {},
					trigger_events = { "VimResized" },
					increment = false,
				},
			})
		end,
	},
	{
		"anuvyklack/windows.nvim",
		dependencies = {
			"anuvyklack/middleclass",
			"anuvyklack/animation.nvim",
		},
		config = function()
			vim.o.winwidth = 10
			vim.o.winminwidth = 10
			vim.o.equalalways = false
			require("windows").setup()
		end,
	},
}
