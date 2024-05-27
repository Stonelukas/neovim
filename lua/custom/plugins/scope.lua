return {
	{
		"tiagovla/scope.nvim",
		config = function()
			require("scope").setup({
				hooks = {
					pre_tab_leave = function()
						vim.api.nvim_exec_autocmds("User", { pattern = "ScopeTabLeavePre" })
						-- [other statements]
					end,

					post_tab_enter = function()
						vim.api.nvim_exec_autocmds("User", { pattern = "ScopeTabEnterPost" })
						-- [other statements]
					end,

					-- [other hooks]
				},

				-- [other options]
			})

			vim.opt.sessionoptions:append("globals")
			require("mini.sessions").setup({
				hooks = {
					pre = {
						write = function()
							vim.api.nvim_exec_autocmds("User", { pattern = "SessionSavePre" })
						end,
					},
				},
			})
		end,
	},
}
