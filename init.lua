-- Set the global leader keys to a space for easier access in command mode
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require 'core.options'
require 'core.keymaps'

-- Define the path where lazy.nvim will be stored locally
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
-- Check if lazy.nvim is already downloaded, if not, clone it from GitHub
if not vim.uv.fs_stat(lazypath) then
	local out vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none", -- This option minimizes data transfer to only essential information
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- Ensures cloning from the stable branch
		lazypath,
	})
	if vim.v.shell_error ~= 0 then
		error('Error cloning lazy.nvim:\n' .. out)
	end
end

-- Add lazy.nvim to the runtime path to allow using `require` on it
---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- Initialize lazy.nvim with the specified configuration directory
require("lazy").setup({
	spec = {
		-- import = "plugins",
	},
	checker = {
		enabled = true,
		notify = true,
	},
	ui = {
		border = "rounded",
		icons = {
			cmd = "⌘",
			config = "🛠",
			event = "📅",
			ft = "📂",
			init = "⚙",
			keys = "🗝",
			plugin = "🔌",
			runtime = "💻",
			source = "📄",
			start = "🚀",
			task = "📌",
			lazy = "💤 ",
		},
	},
	change_detection = {
		notify = false, -- Disable notifications for changes
	},
{
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
	}
}
})
