return {
	{
		"natecraddock/workspaces.nvim",
		config = function()
			local workspaces = require("workspaces")
			-- returns true if `dir` is a child of `parent`
			local is_dir_in_parent = function(dir, parent)
				if parent == nil then
					return false
				end
				local ws_str_find, _ = string.find(dir, parent, 1, true)
				if ws_str_find == 1 then
					return true
				else
					return false
				end
			end

			-- convenience function which wraps is_dir_in_parent with active file
			-- and workspace.
			local current_file_in_ws = function()
				local workspaces = require("workspaces")
				local ws_path = require("workspaces.util").path
				local current_ws = workspaces.path()
				local current_file_dir = ws_path.parent(vim.fn.expand("%:p", true))

				return is_dir_in_parent(current_file_dir, current_ws)
			end

			-- set workspace when changing buffers
			local my_ws_grp = vim.api.nvim_create_augroup("my_ws_grp", { clear = true })
			vim.api.nvim_create_autocmd({ "BufEnter", "VimEnter" }, {
				callback = function()
					-- do nothing if not file type
					local buf_type = vim.api.nvim_get_option_value("buftype", { buf = 0 })
					if buf_type ~= "" and buf_type ~= "acwrite" then
						return
					end

					-- do nothing if already within active workspace
					if current_file_in_ws() then
						return
					end

					local workspaces = require("workspaces")
					local ws_path = require("workspaces.util").path
					local current_file_dir = ws_path.parent(vim.fn.expand("%:p", true))

					-- filtered_ws contains workspace entries that contain current file
					local filtered_ws = vim.tbl_filter(function(entry)
						return is_dir_in_parent(current_file_dir, entry.path)
					end, workspaces.get())

					-- select the longest match
					local selected_workspace = nil
					for _, value in pairs(filtered_ws) do
						if not selected_workspace then
							selected_workspace = value
						end
						if string.len(value.path) > string.len(selected_workspace.path) then
							selected_workspace = value
						end
					end

					if selected_workspace then
						workspaces.open(selected_workspace.name)
					end
				end,

				group = my_ws_grp,
			})

			-- use below example if using any `open` hooks, such as telescope, otherwise
			-- the hook will run every time when switching to a buffer from a different
			-- workspace.
			workspaces.setup({
				-- path to a file to store workspaces data in
				-- on a unix system this would be ~/.local/share/nvim/workspaces
				path = vim.fn.stdpath("data") .. "/workspaces",

				-- to change directory for nvim (:cd), or only for window (:lcd)
				-- deprecated, use cd_type instead
				-- global_cd = true,

				-- controls how the directory is changed. valid options are "global", "local", and "tab"
				--   "global" changes directory for the neovim process. same as the :cd command
				--   "local" changes directory for the current window. same as the :lcd command
				--   "tab" changes directory for the current tab. same as the :tcd command
				--
				-- if set, overrides the value of global_cd
				cd_type = "global",

				-- sort the list of workspaces by name after loading from the workspaces path.
				sort = true,

				-- sort by recent use rather than by name. requires sort to be true
				mru_sort = true,

				-- option to automatically activate workspace when opening neovim in a workspace directory
				auto_open = true,

				-- enable info-level notifications after adding or removing a workspace
				notify_info = true,

				-- lists of hooks to run after specific actions
				-- hooks can be a lua function or a vim command (string)
				-- lua hooks take a name, a path, and an optional state table
				-- if only one hook is needed, the list may be omitted
				hooks = {
					add = {},
					remove = {},
					rename = {},
					open_pre = {},
					open = function()
						-- do not run hooks if file already in active workspace

						if current_file_in_ws() then
							return false
						end
					end,

					function()
						require("telescope.builtin").find_files()
					end,
				},
			})
			-- vim.api.nvim_create_autocmd("VimEnter", {
			-- 	callback = function()
			-- 		require("sessions").load(
			-- 			".nvim/session/home.stonelukas..config.nvim.session",
			-- 			{ silent = false, autosave = true }
			-- 		)
			-- 	end,
			-- })
		end,
	},
}
