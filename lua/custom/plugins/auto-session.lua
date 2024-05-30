return {

	{
		"rmagatti/session-lens",
		dependencies = {
			"rmagatti/auto-session",
			"nvim-telescope/telescope.nvim",
		},
		config = function()
			require("session-lens").setup({
				path_display = { "shorten" },
				theme = "ivy",
				theme_conf = { border = true },
				previewer = true,
				prompt_title = "SESSIONS",
				show_icon = true,
			})
		end,
	},
	{
		"rmagatti/auto-session",
		config = function()
			-- 	require("auto-session").setup({
			-- 		log_level = "error",
			-- 		auto_session_enable_last_session = vim.loop.cwd() == vim.loop.os_homedir(),
			-- 		auto_session_root_dir = vim.fn.stdpath("data") .. "/sessions/",
			-- 		auto_restore_enable = false,
			-- 		auto_save_enabled = false,
			-- 		auto_session_use_git_branch = false,
			-- 		cwd_chang_handling = {
			-- 			restore_upcoming_session = false,
			-- 			post_cwd_changed_hook = function()
			-- 				require("lualine").refresh()
			-- 			end,
			-- 		},
			-- 		auto_session_suppress_dirs = nil,
			-- 		session_lens = {
			-- 			buftypes_to_ignore = {},
			-- 			load_on_setup = false,
			-- 			theme_conf = { border = true },
			-- 			previewer = true,
			-- 		},
			-- 	})
			-- 	vim.keymap.set("n", "<leader>ls", ":SearchSession<CR>", { desc = "Open Telescope window with sessions" })
			-- 	vim.keymap.set("n", "<leader>lw", ":SessionSave<CR>", { desc = "Save session for auto session root dir" })
			-- 	vim.keymap.set("n", "<leader>lr", ":SessionRestore<CR>", { desc = "Restore session for cwd" })
		end,
	},
}
