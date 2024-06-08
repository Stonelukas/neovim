local fzf = require("fzf")

require("fzf-lua").setup({
	"telescope",
	winopts = { preview = { default = "bat" } },
	lsp = {
		async_or_timeout = 3000,
	},
})

vim.api.nvim_create_autocmd("VimResized", {
	pattern = "*",
	command = 'lua require("fzf-lua").redraw()',
})

vim.keymap.set("n", "<c-P>", "<cmd>FzfxFiles<cr>", { silent = true, desc = "search files in cwd" })

vim.keymap.set(
	"x",
	"<leader>fv",
	"<cmd>FzfxFiles visual<cr>",
	{ silent = true, desc = "search files in cwd in Visual" }
)

vim.keymap.set("n", "<leader>cs", function()
	require("fzf-lua").colorschemes({ resume = true })
end, { silent = true, desc = "Change ColorScheme with live preview" })

vim.keymap.set("n", "<leader>gc", "<cmd>FzfxGCommits<cr>", { silent = true, desc = "show git commits" })

vim.keymap.set("n", "<leader>bu", function()
	require("fzf-lua").buffers({ resume = true })
end, { silent = true, desc = "show current Buffers" })

vim.keymap.set("n", "<leader><leader>", function()
	require("fzf-lua").oldfiles({ resume = false })
end, { silent = true, desc = "show old files" })

vim.keymap.set("n", "<leader>fh", function()
	require("fzf-lua").helptags({ resume = true })
end, { silent = true, desc = "show helptags" })

vim.keymap.set("n", "<leader>fg", function()
	require("fzf-lua").live_grep({ resume = true })
end, { silent = true, desc = "open live Grep" })

vim.keymap.set("n", "<leader>.", function()
	require("fzf-lua").files({ resume = true, cwd = vim.fn.expand('%:p:h"') })
end, { silent = true, desc = "open files in cwd" })

vim.keymap.set("n", "<leader>k", function()
	require("fzf-lua").builtin({ resume = true })
end, { silent = true, desc = "open files in cwd" })

vim.keymap.set({ "n", "v", "i" }, "<C-x><C-f>", function()
	require("fzf-lua").complete_path({
		cmd = "rp --line-number --colomn --color=always",
	})
end, { silent = true, desc = "Fuzzy complete path" })

vim.keymap.set({ "n", "v", "i" }, "<C-x><C-f>", function()
	require("fzf-lua").complete_file({
		cmd = "rp --line-number --colomn --color=always",
		winopts = { preview = { hidden = "nohidden" } },
	})
end, { silent = true, desc = "Fuzzy complete file" })
