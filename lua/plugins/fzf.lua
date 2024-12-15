return {
	{ "junegunn/fzf", build = "./install --all" },
	{
		"vijaymarupudi/nvim-fzf-commands",
	},
	{
		"ibhagwan/fzf-lua",
		cond = false,
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			-- require("custom.fzf")
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
