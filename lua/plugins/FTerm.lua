return {
	{
		"numToStr/FTerm.nvim",
		cond = false,
		config = function()
			require("FTerm").setup({
				border = "rounded",
				lualine_bold = true,
			})

			vim.keymap.set("n", "<A-i>", function()
				require("FTerm").toggle()
			end)

			local fterm = require("FTerm")

			local gitui = fterm:new({
				ft = "fterm_gitui", -- You can also override the default filetype, if you want
				cmd = "gitui",
				dimensions = {
					height = 0.9,
					width = 0.9,
				},
			})

			-- Use this to toggle gitui in a floating terminal
			vim.keymap.set("n", "<A-g>", function()
				gitui:toggle()
			end)

			local fterm = require("FTerm")

			local btop = fterm:new({
				ft = "fterm_btop",
				cmd = "btop",
			})

			-- Use this to toggle btop in a floating terminal
			vim.keymap.set("n", "<A-b>", function()
				btop:toggle()
			end)

			vim.api.nvim_create_user_command("FTermOpen", require("FTerm").open, { bang = true })
			vim.api.nvim_create_user_command("FTermClose", require("FTerm").close, { bang = true })
			vim.api.nvim_create_user_command("FTermExit", require("FTerm").exit, { bang = true })
			vim.api.nvim_create_user_command("FTermToggle", require("FTerm").toggle, { bang = true })
		end,
	},
}
