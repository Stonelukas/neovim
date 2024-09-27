return {
	{
		"nvimtools/hydra.nvim",
		cond = true,
		-- commander = {
		-- 	{
		-- 		desc = "show all commands in git mode",
		-- 		cmd = "<CMD>Telescope command_center category=" .. "Git_Mode" .. "<CR>",
		-- 		keybindings = { "n", "?", { noremap = true } },
		-- 	},
		-- 	{
		-- 		desc = "Exit git mode",
		-- 		cmd = "<leader>hg",
		-- 		keybindings = { "n", "<leader>g", { nowait = true } },
		-- 		hydra_head_args = { exit = true },
		-- 		category = "Git_Mode",
		-- 	},
		-- 	{
		-- 		desc = "Next hunk",
		-- 		cmd = function()
		-- 			if vim.wo.diff then
		-- 				return "]c"
		-- 			end
		-- 			vim.schedule(function()
		-- 				require("gitsigns").next_hunk()
		-- 			end)
		-- 			return "<Ignore>"
		-- 		end,
		--
		-- 		keybindings = { "n", "<C-n>", { noremap = true, expr = true } },
		-- 		category = "Git_Mode",
		-- 	},
		-- 	{
		-- 		desc = "Previous hunk",
		-- 		cmd = function()
		-- 			if vim.wo.diff then
		-- 				return "[c"
		-- 			end
		-- 			vim.schedule(function()
		-- 				require("gitsigns").prev_hunk()
		-- 			end)
		-- 			return "<Ignore>"
		-- 		end,
		--
		-- 		keybindings = { "n", "<C-p>", { noremap = true, expr = true } },
		-- 		category = "Git_Mode",
		-- 	},
		-- 	{
		-- 		desc = "Stage hunk",
		-- 		cmd = require("gitsigns").stage_hunk,
		-- 		keybindings = { "n", "s", {} },
		-- 		category = "Git_Mode",
		-- 	},
		-- 	{
		-- 		desc = "Undo stage hunk",
		-- 		cmd = require("gitsigns").undo_stage_hunk,
		-- 		keybindings = { "n", "u", {} },
		-- 		category = "Git_Mode",
		-- 	},
		-- 	{
		-- 		desc = "Stage buffer",
		-- 		cmd = require("gitsigns").stage_buffer,
		-- 		keybindings = { "n", "S", {} },
		-- 		category = "Git_Mode",
		-- 	},
		-- 	{
		-- 		desc = "Preview hunk",
		-- 		cmd = require("gitsigns").preview_hunk,
		-- 		keybindings = { "n", "K", {} },
		-- 		category = "Git_Mode",
		-- 	},
		-- 	{
		-- 		desc = "View line blame",
		-- 		cmd = require("gitsigns").blame_line,
		-- 		keybindings = { "n", "b", {} },
		-- 		category = "Git_Mode",
		-- 	},
		-- 	{
		-- 		desc = "Toggle deleted",
		-- 		cmd = require("gitsigns").toggle_deleted,
		-- 		keybindings = { "n", "<leader>d", {} },
		-- 		category = "Git_Mode",
		-- 	},
		-- 	{
		-- 		desc = "View line blame (full)",
		-- 		cmd = function()
		-- 			require("gitsigns").blame_line({ full = true })
		-- 		end,
		-- 		keybindings = { "n", "B", {} },
		-- 		category = "Git_Mode",
		-- 	},
		-- 	{
		-- 		desc = "Open neogit",
		-- 		cmd = "<CMD>Neogit<CR>",
		-- 		keybindings = { "n", "c", {} },
		-- 		category = "Git_Mode",
		-- 	},
		-- 	{
		-- 		desc = "Open diffview",
		-- 		cmd = "<CMD>DiffviewOpen<CR>",
		-- 		keybindings = { "n", "dv", {} },
		-- 		category = "Git_Mode",
		-- 	},
		-- 	{
		-- 		desc = "Open file commit history panel",
		-- 		cmd = "<CMD>DiffviewFileHistory<CR>",
		-- 		keybindings = { "n", "df", {} },
		-- 		category = "Git_Mode",
		-- 	},
		-- 	{
		-- 		desc = "Close diffview/file commit history panel",
		-- 		cmd = "<CMD>DiffviewClose<CR>",
		-- 		keybindings = { "n", "q", {} },
		-- 		category = "Git_Mode",
		-- 	},
		-- },
		config = function()
			-- configuration
			local Hydra = require("hydra")
			Hydra.setup({
				color = "red",
			})
			require("plugins.hydra.config")
		end,
	},
}
