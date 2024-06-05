return {
	--[[ {
		"natecraddock/sessions.nvim",
		config = function()
			local sessions = require("sessions")
			require("sessions").setup({
				events = { "VimLeavePre" },
				session_filepath = nil,
				absolute = false,
				autosave = false,
			})

			sessions.start_autosave()
			vim.keymap.set("n", "<leader>ss", function()
				sessions.save(".nvim/session/home.stonelukas..config.nvim.session", { autosave = true })
			end)

			vim.keymap.set("n", "<leader>ls", function()
				sessions.load(".nvim/session/home.stonelukas..config.nvim.session", { autosave = true })
			end)
		end,
	}, ]]
	{
		"olimorris/persisted.nvim",
		priority = 1000,
		lazy = false,
		config = function()
			require("persisted").setup({
				save_dir = vim.fn.expand(vim.fn.stdpath("data") .. "/sessions/"), -- directory where session files are saved
				silent = true, -- silent nvim message when sourcing session file
				use_git_branch = true, -- create session files based on the branch of a git enabled repository
				default_branch = "main", -- the branch to load if a session file is not found for the current branch
				autosave = true, -- automatically save session files when exiting Neovim
				should_autosave = function() -- function to determine if a session should be autosaved
					-- do not autosave if the alpha dashboard is the current filetype
					if vim.bo.filetype == "alpha" then
						return false
					end
					return true
				end,
				autoload = false, -- automatically load the session for the cwd on Neovim startup
				on_autoload_no_session = nil, -- function to run when `autoload = true` but there is no session to load
				follow_cwd = true, -- change session file name to match current working directory if it changes
				allowed_dirs = { "~/.config" }, -- table of dirs that the plugin will auto-save and auto-load from
				ignored_dirs = nil, -- table of dirs that are ignored when auto-saving and auto-loading
				ignored_branches = nil, -- table of branch patterns that are ignored for auto-saving and auto-loading
				telescope = {
					reset_prompt = true, -- Reset the Telescope prompt after an action?
					mappings = { -- table of mappings for the Telescope extension
						change_branch = "<c-b>",
						copy_session = "<c-c>",
						delete_session = "<c-d>",
					},
					icons = { -- icons displayed in the picker, set to nil to disable entirely
						branch = " ",
						dir = " ",
						selected = " ",
					},
				},
			})

			local group = vim.api.nvim_create_augroup("PersistedHooks", {})

			vim.api.nvim_create_autocmd({ "User" }, {
				pattern = "PersistedTelescopeLoadPre",
				group = group,
				callback = function(session)
					-- Save the currently loaded session using a global variable
					require("persisted").save({ session = vim.g.persisted_loaded_session })

					-- Delete all of the open buffers
					vim.api.nvim_input("<ESC>:%bd!<CR>")
				end,
			})

			vim.api.nvim_create_autocmd("User", {
				pattern = "PersistedLoadPost",
				group = group,
				callback = function(session)
					vim.notify("Loaded session " .. session.data.name, vim.log.levels.INFO, { title = title })
				end,
			})
		end,
	},
}
