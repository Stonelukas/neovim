--[[
-- Setup initial configuration,
--
-- Primarily just download and execute lazy.nvim
--]]
-- Set the global leader keys to a space for easier access in command mode
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Define the path where lazy.nvim will be stored locally
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
-- Check if lazy.nvim is already downloaded, if not, clone it from GitHub
if not vim.uv.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",  -- This option minimizes data transfer to only essential information
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",  -- Ensures cloning from the stable branch
		lazypath,
	})
end

-- Add lazy.nvim to the runtime path to allow using `require` on it
---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- Initialize lazy.nvim with the specified configuration directory
require("lazy").setup({ import = "custom/plugins" }, {
	change_detection = {
		notify = false,  -- Disable notifications for changes
	},
})

-- Configure completion options for better user experience in command-line mode
vim.opt.completeopt = { "menu", "menuone", "noselect", "preview" }
-- Append 'c' to shortmess to avoid showing extra completion messages
vim.opt.shortmess:append("c")