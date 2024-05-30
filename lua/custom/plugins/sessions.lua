return {
	{
		"natecraddock/sessions.nvim",
		config = function()
			require("sessions").setup({
				events = { "WinEnter" },
				session_filepath = ".nvim/session",
				absolute = true,
			})
		end,
	},
}
