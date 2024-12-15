return {
    {
        "numToStr/FTerm.nvim",
        cond = true,
        config = function()
            require("FTerm").setup({
                border = "rounded",
                lualine_bold = true,
            })

            vim.keymap.set("n", "<A-g>", function()
                require("FTerm").toggle()
            end)

            vim.keymap.set('t', '<A-i>', '<C-\\><C-n><CMD>lua require("FTerm").toggle()<CR>')

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
