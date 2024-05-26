return {
	{
		"rmagatti/session-lens",
		config = function()
			require("session-lens").setup({
				theme = "dropdown",
				prompt_title = "SESSIONS",
				show_icon = true,
			})
		end,
	},
	{
		"rmagatti/auto-session",
		config = function()
			require("auto-session").setup({
				log_level = "info",
				auto_session_enable_last_session = true,
				auto_session_root_dir = vim.fn.stdpath("data") .. "/sessions/",
				auto_restore_enable = false,
				auto_save_enabled = true,
				auto_session_use_git_branch = true,
				-- auto_session_suppress_dirs = { "~/", "~/.config/", "~/.config/nvim/" },
				session_lens = {
					buftypes_to_ignore = {},
					load_on_setup = false,
					theme_conf = { border = true },
					previewer = true,
				},
			})
			vim.keymap.set("n", "<leader>ls", ":SearchSession<CR>", { desc = "Open Telescope window with sessions" })
			vim.keymap.set("n", "<leader>lw", ":SessionSave", { desc = "Save session for auto session root dir" })
			vim.keymap.set("n", "<leader>lr", ":SessionRestore<CR>", { desc = "Restore session for cwd" })
			vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
		end,
	},
}
