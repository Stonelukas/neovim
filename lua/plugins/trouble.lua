return {
	{
		"folke/trouble.nvim",
		branch = "main",
		keys = {
			{
				"<leader>dt",
				"<cmd>Trouble diagnostics toggle<cr>",
				desc = "Diagnostics (Trouble)",
			},
			{
				"<leader>dT",
				"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
				desc = "Buffer Diagnostics (Trouble)",
			},
			{
				"<leader>st",
				"<cmd>Trouble symbols toggle focus=false<cr>",
				desc = "Symbols (Trouble)",
			},
			{
				"<leader>lt",
				"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
				desc = "LSP Definitions / references / ... (Trouble)",
			},
			{
				"<leader>Lt",
				"<cmd>Trouble loclist toggle<cr>",
				desc = "Location List (Trouble)",
			},
			{
				"<leader>qt",
				"<cmd>Trouble qflist toggle<cr>",
				desc = "Quickfix List (Trouble)",
			},
		},
		opts = {},
		config = function()
			require("trouble").setup({
				auto_close = true,
				auto_jump = true,
				auto_open = false,
				auto_preview = true,
				auto_refresh = true,
				debug = true,
				focus = true,
				pinned = false,
				preview = {
					type = "main",
				},
				keys = {
					["?"] = "help",
					r = "refresh",
					R = "toggle_refresh",
					q = "close",
					o = "jump_close",
					["<esc>"] = "cancel",
					["<cr>"] = "jump",
					["<2-leftmouse>"] = "jump",
					["<c-s>"] = "jump_split",
					["<c-v>"] = "jump_vsplit",
					-- go down to next item (accepts count)
					-- j = "next",
					["}"] = "next",
					["]]"] = "next",
					-- go up to prev item (accepts count)
					-- k = "prev",
					["{"] = "prev",
					["[["] = "prev",
					i = "inspect",
					p = "preview",
					P = "toggle_preview",
					zo = "fold_open",
					zO = "fold_open_recursive",
					zc = "fold_close",
					zC = "fold_close_recursive",
					za = "fold_toggle",
					zA = "fold_toggle_recursive",
					zm = "fold_more",
					zM = "fold_close_all",
					zr = "fold_reduce",
					zR = "fold_open_all",
					zx = "fold_update",
					zX = "fold_update_all",
					zn = "fold_disable",
					zN = "fold_enable",
					zi = "fold_toggle_enable",
				},
			})

			-- Diagnostic signs
			-- https://github.com/folke/trouble.nvim/issues/52
			local signs = {
				Error = " ",
				Warning = " ",
				Hint = " ",
				Information = " ",
			}
			for type, icon in pairs(signs) do
				local hl = "DiagnosticSign" .. type
				vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
			end
		end,
	},
}
