-- Load the fzf module
local fzf = require("fzf")

-- Setup configuration for fzf-lua with specific options
require("fzf-lua").setup({
	"telescope",  -- Use telescope as a picker
	winopts = { preview = { default = "bat" } },  -- Use 'bat' for file previews
	lsp = {
		async_or_timeout = 3000,  -- Set timeout for LSP async operations to 3000ms
	},
})

-- Create an autocommand that redraws fzf-lua when Vim is resized
vim.api.nvim_create_autocmd("VimResized", {
	pattern = "*",  -- Apply to all files
	command = 'lua require("fzf-lua").redraw()',  -- Command to redraw fzf-lua
})

-- Map <c-P> to open file search in normal mode
vim.keymap.set("n", "<c-P>", "<cmd>FzfxFiles<cr>", { silent = true, desc = "search files in cwd" })

-- Map <leader>fv to open file search in visual mode
vim.keymap.set(
	"x",
	"<leader>fv",
	"<cmd>FzfxFiles visual<cr>",
	{ silent = true, desc = "search files in cwd in Visual" }
)

-- Map <leader>cs to change colorschemes with a live preview
vim.keymap.set("n", "<leader>cs", function()
	require("fzf-lua").colorschemes({ resume = true })
end, { silent = true, desc = "Change ColorScheme with live preview" })

-- Map <leader>gc to show git commits
vim.keymap.set("n", "<leader>gc", "<cmd>FzfxGCommits<cr>", { silent = true, desc = "show git commits" })

-- Map <leader>bu to show buffer list
vim.keymap.set("n", "<leader>bu", function()
	require("fzf-lua").buffers({ resume = true })
end, { silent = true, desc = "show current Buffers" })

-- Map <leader><leader> to show old files
vim.keymap.set("n", "<leader><leader>", function()
	require("fzf-lua").oldfiles({ resume = false })
end, { silent = true, desc = "show old files" })

-- Map <leader>fh to show help tags
vim.keymap.set("n", "<leader>fh", function()
	require("fzf-lua").helptags({ resume = true })
end, { silent = true, desc = "show helptags" })

-- Map <leader>fg to start live grep
vim.keymap.set("n", "<leader>fg", function()
	require("fzf-lua").live_grep({ resume = true })
end, { silent = true, desc = "open live Grep" })

-- Map <leader>. to open files in the current working directory
vim.keymap.set("n", "<leader>.", function()
	require("fzf-lua").files({ resume = true, cwd = vim.fn.expand('%:p:h"') })
end, { silent = true, desc = "open files in cwd" })

-- Map <leader>k to open built-in fzf-lua functions
vim.keymap.set("n", "<leader>k", function()
	require("fzf-lua").builtin({ resume = true })
end, { silent = true, desc = "open files in cwd" })

-- Map <C-x><C-f> to complete path in normal, visual, and insert modes
vim.keymap.set({ "n", "v", "i" }, "<C-x><C-f>", function()
	require("fzf-lua").complete_path({
		cmd = "rp --line-number --colomn --color=always",
	})
end, { silent = true, desc = "Fuzzy complete path" })

-- Map <C-x><C-f> to complete file in normal, visual, and insert modes
vim.keymap.set({ "n", "v", "i" }, "<C-x><C-f>", function()
	require("fzf-lua").complete_file({
		cmd = "rp --line-number --colomn --color=always",
		winopts = { preview = { hidden = "nohidden" } },
	})
end, { silent = true, desc = "Fuzzy complete file" })
