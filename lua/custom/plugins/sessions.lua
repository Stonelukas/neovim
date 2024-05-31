return {
	{
		"natecraddock/sessions.nvim",
		config = function()
			local sessions = require("sessions")
			require("sessions").setup({
				events = { "VimLeavePre" },
				session_filepath = nil,
				absolute = false,
				autosave = true,
			})

			sessions.start_autosave()
			vim.keymap.set("n", "<leader>ss", function()
				sessions.save(".nvim/session/home.stonelukas..config.nvim.session", { autosave = true })
			end)

			vim.keymap.set("n", "<leader>ls", function()
				sessions.load(".nvim/session/home.stonelukas..config.nvim.session", { autosave = true })
			end)
		end,
	},
}
