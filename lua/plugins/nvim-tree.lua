--   https://github.com/nvim-tree/nvim-tree.lua
return {
	"nvim-tree/nvim-tree.lua",
	dependencies = {
		{
			"JMarkin/nvim-tree.lua-float-preview",
			lazy = true,
			opts = {
				toggled_on = true,
			},
		},
	},
	version = "*",
	cond = true,
	config = function()
		local api = require("nvim-tree.api")

		local function my_on_attach(bufnr)
			local api = require("nvim-tree.api")
			local FloatPreview = require("float-preview")
			function find_directory_and_focus()
				local actions = require("telescope.actions")
				local action_state = require("telescope.actions.state")

				local function open_nvim_tree(prompt_bufnr, _)
					actions.select_default:replace(function()
						local api = require("nvim-tree.api")

						actions.close(prompt_bufnr)
						local selection = action_state.get_selected_entry()
						api.tree.open()
						api.tree.find_file(selection.cwd .. "/" .. selection.value)
					end)
					return true
				end

				require("telescope.builtin").find_files({
					find_command = { "fd", "--type", "directory", "--hidden", "--exclude", ".git/*" },
					attach_mappings = open_nvim_tree,
				})
			end

			local treeutils = require("core.code.treeutils")

			FloatPreview.attach_nvimtree(bufnr)

			api.events.subscribe(api.events.Event.FileCreated, function(file)
				vim.cmd("edit" .. file.fname)
			end)

			-- https://github.com/nvim-tree/nvim-tree.lua/wiki/Recipes#show-dynamic-actions-popup
			require("plugins.hydra.nvim-tree-hydra")

			-- Git
			local git_add = function()
				local node = api.tree.get_node_under_cursor()
				local gs = node.git_status.file

				-- if the current node is a directory get children status
				if gs == nil then
					gs = (node.git_status.dir.direct ~= nil and node.git_status.dir.direct[1])
						or (node.git_status.dir.indirect ~= nil and node.git_status.dir.indirect[1])
				end

				-- if the file is untracked, unstaged or partially staged, we stage it
				if gs == "??" or gs == "MM" or gs == "AM" or gs == " M" then
					vim.cmd("silent !git add " .. node.absolute_path)

					-- if the file is staged, we unstage
				elseif gs == "M " or gs == "A " then
					vim.cmd("silent !git restore --staged " .. node.absolute_path)
				end

				api.tree.reload()
			end

			-- multiple files at once
			-- mark operation
			local mark_move_j = function()
				api.marks.toggle()
				vim.cmd("norm j")
			end
			local mark_move_k = function()
				api.makrs.toggle()
				vim.cmd("norm k")
			end

			--marked ifles operation
			local mark_trash = function()
				local marks = api.marks.list()
				if #marks == 0 then
					table.insert(marks, api.tree.get_node_under_cursor())
				end
				vim.ui.input({ prompt = string.format("Trash %s files? [Y/n] ", #marks) }, function(input)
					if input == "y" or input == "Y" or input == " " then
						for _, node in ipairs(marks) do
							api.fs.trash(node)
						end
						api.marks.clear()
						api.tree.reload()
					end
				end)
			end
			local mark_remove = function()
				local marks = api.marks.list()
				if #marks == 0 then
					table.insert(marks, api.tree.get_node_under_cursor())
				end
				vim.ui.input({ prompt = string.format("Remove/Delete %s files? [Y/n] ", #marks) }, function(input)
					if input == "y" or input == "Y" or input == " " then
						for _, node in ipairs(marks) do
							api.fs.remove(node)
						end
						api.marks.clear()
						api.tree.reload()
					end
				end)
			end

			local mark_copy = function()
				local marks = api.marks.list()
				if #marks == 0 then
					table.insert(marks, api.tree.get_node_under_cursor())
				end
				for _, node in ipairs(marks) do
					api.fs.copy.node(node)
				end
				api.marks.clear()
				api.tree.reload()
			end
			local mark_cut = function()
				local marks = api.marks.list()
				if #marks == 0 then
					table.insert(marks, api.tree.get_node_under_cursor())
				end
				for _, node in ipairs(marks) do
					api.fs.cut.node(node)
				end
				api.marks.clear()
				api.tree.reload()
			end

			local function opts(desc)
				return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
			end

			-- dafault mappings
			api.config.mappings.default_on_attach(bufnr)

			-- delete mappings
			vim.keymap.del("n", "<C-]>", { buffer = bufnr })

			-- custom mappings
			vim.keymap.set("n", "?", api.tree.toggle_help, opts("Help"))
			vim.keymap.set("n", "l", api.tree.change_root_to_node, opts("CD"))
			vim.keymap.set("n", "ga", git_add, opts("Git Add"))
			vim.keymap.set("n", "P", api.fs.paste, opts("Paste"))
			vim.keymap.set("n", "J", mark_move_j, opts("Toggle Bookmark Down"))
			vim.keymap.set("n", "K", mark_move_k, opts("Toggle Bookmark Up"))
			vim.keymap.set("n", "dd", mark_cut, opts("Cut File(s)"))
			vim.keymap.set("n", "df", mark_trash, opts("Trash File(s)"))
			vim.keymap.set("n", "dF", mark_remove, opts("Remove File(s)"))
			vim.keymap.set("n", "yy", mark_copy, opts("Copy File(s)"))
			vim.keymap.set("n", "mv", api.marks.bulk.move, opts("Move Bookmarked"))

			vim.keymap.set("n", "<c-f>", treeutils.launch_find_files, opts("Launch Find Files"))
			vim.keymap.set("n", "<c-g>", treeutils.launch_live_grep, opts("Launch Live Grep"))
			vim.keymap.set("n", "fd", find_directory_and_focus, opts("find and focus Directory (Telescope)"))
		end

		-- Statusline
		api.events.subscribe(api.events.Event.TreeOpen, function()
			local tree_winid = api.tree.winid()

			if tree_winid ~= nil then
				vim.api.nvim_set_option_value("statusline", "%t", { win = tree_winid })
			end
		end)

		require("nvim-tree").setup({
			on_attach = my_on_attach,
			hijack_cursor = true,
			sync_root_with_cwd = true,
			sort = {
				sorter = "name",
			},
			view = {
				centralize_selection = true,
				width = 50,
			},
			renderer = {
				group_empty = true,
				hidden_display = "all",
				highlight_git = "all",
				highlight_diagnostics = "all",
				highlight_opened_files = "all",
				highlight_modified = "all",
				indent_markers = {
					enable = true,
				},
				icons = {
					web_devicons = {
						folder = {
							enable = true,
						},
					},
				},
			},
			update_focused_file = {
				enable = true,
				update_root = {
					enable = false,
				},
			},
			diagnostics = {
				enable = true,
			},
			modified = {
				enable = true,
			},
			filters = {
				dotfiles = false,
				git_ignored = false,
			},
			actions = {
				open_file = {
					quit_on_open = true,
				},
			},
			trash = {
				cmd = "trash",
			},
			ui = {
				confirm = {
					default_yes = true,
				},
			},
		})

		-- global
		vim.keymap.set(
			"n",
			"<leader>ä",
			"<cmd>NvimTreeToggle<cr>",
			{ desc = "Nvim-Tree", silent = true, noremap = true }
		)
	end,
}
