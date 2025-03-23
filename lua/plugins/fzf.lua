return {
	{ "junegunn/fzf", build = "./install --all" },
	{
		"vijaymarupudi/nvim-fzf-commands",
	},
	{
		"ibhagwan/fzf-lua",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			local fzf_lua = require("fzf-lua")

			-- Configure fzf-lua options
			fzf_lua.setup({
				-- Global fzf-lua options
				global_resume = true,
				global_resume_query = true,
				winopts = {
					height = 0.85,
					width = 0.80,
					preview = {
						scrollbar = "float",
						layout = "vertical",
						vertical = "down:45%",
					},
				},
				keymap = {
					fzf = {
						["ctrl-q"] = "select-all+accept",
					},
				},
			})

			-- Set up keymappings

			-- File finding
			vim.keymap.set("n", "<leader>ff", fzf_lua.files, { desc = "FZF: Find files" })
			vim.keymap.set("n", "<leader>fg", fzf_lua.git_files, { desc = "FZF: Find git files" })
			vim.keymap.set("n", "<leader>fr", fzf_lua.oldfiles, { desc = "FZF: Recent files" })

			-- Grep/Search
			vim.keymap.set("n", "<leader>fs", fzf_lua.live_grep, { desc = "FZF: Live grep" })
			vim.keymap.set("n", "<leader>fw", fzf_lua.grep_cword, { desc = "FZF: Grep current word" })

			-- Buffer operations
			vim.keymap.set("n", "<leader>fb", fzf_lua.buffers, { desc = "FZF: Buffers" })

			-- Git operations
			vim.keymap.set("n", "<leader>gcc", fzf_lua.git_commits, { desc = "FZF: Git commits" })
			vim.keymap.set("n", "<leader>gb", fzf_lua.git_branches, { desc = "FZF: Git branches" })
			vim.keymap.set("n", "<leader>gs", fzf_lua.git_status, { desc = "FZF: Git status" })

			-- Command and search history
			vim.keymap.set("n", "<leader>fc", fzf_lua.command_history, { desc = "FZF: Command history" })
			vim.keymap.set("n", "<leader>fh", fzf_lua.search_history, { desc = "FZF: Search history" })

			-- LSP
			vim.keymap.set("n", "<leader>fd", fzf_lua.lsp_definitions, { desc = "FZF: LSP definitions" })
			vim.keymap.set("n", "<leader>fr", fzf_lua.lsp_references, { desc = "FZF: LSP references" })
			vim.keymap.set("n", "<leader>fi", fzf_lua.lsp_implementations, { desc = "FZF: LSP implementations" })
		end,
	},
	{
		-- TODO: look into replacing this with some of telescope
		"linrongbin16/fzfx.nvim",
		cond = false,
		dependencies = { "nvim-tree/nvim-web-devicons", "junegunn/fzf" },

		-- specify version to avoid break changes
		version = "v5.*",

		config = function()
			require("fzfx").setup({
				buffers = {

					fzf_opts = {
						"--info=hidden",
						"--padding=0",
						"--header=",
						"--preview-window=hidden",
					},

					win_opts = function()
						local bufs_fn_len = {}
						local max_len = 0

						for _, buf_nr in ipairs(vim.api.nvim_list_bufs()) do
							if vim.api.nvim_buf_is_valid(buf_nr) then
								local buf_listed = vim.api.nvim_get_option_value("buflisted", { buf = buf_nr })
								local buf_nm = vim.api.nvim_buf_get_name(buf_nr)
								buf_nm = vim.fn.expand(buf_nm)
								if buf_listed then
									if buf_nm ~= "" then
										buf_nm = vim.fn.substitute(buf_nm, vim.fn.getcwd(), "", "g")
										buf_nm = vim.fn.substitute(buf_nm, vim.fn.expand("$HOME"), "~", "g")
										buf_nm = vim.fs.basename(buf_nm)
										buf_len = string.len(buf_nm)
										table.insert(bufs_fn_len, buf_len)
									end
								end
							end
						end

						for _, len in ipairs(bufs_fn_len) do
							max_len = math.max(max_len, len)
						end

						popup = {
							height = #bufs_fn_len + 3,
							width = max_len + 3,
							relative = "win",
							zindex = 51,
						}
						return popup
					end,
				},
			})
		end,
	},
}
