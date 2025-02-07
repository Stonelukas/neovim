-- Set the global leader keys to a space for easier access in command mode
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

if vim.env.PROF then
	-- example for lazy.nvim
	-- change this to the correct path for your plugin manager
	local snacks = vim.fn.stdpath("data") .. "/lazy/snacks.nvim"
	vim.opt.rtp:append(snacks)
	require("snacks.profiler").startup({
		startup = {
			event = "VimEnter", -- stop profiler on this event. Defaults to `VimEnter`
			-- event = "UIEnter",
			-- event = "VeryLazy",
		},
	})
end

vim.g.base46_cache = vim.fn.stdpath("data") .. "/base46_cache"

-- Define the path where lazy.nvim will be stored locally
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
-- Check if lazy.nvim is already downloaded, if not clone it from GitHub
if not vim.uv.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none", -- This option minimizes data transfer to only essential information
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- Ensures cloning from the stable branch
		lazypath,
	})
end

-- Add "lazy.nvim" to the runtime path to allow using `require` on it
---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- Disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Initialize "lazy.nvim" with the specified configuration directory
---@type LazyConfig
require("lazy").setup({
	rocks = {
		hererocks = true,
	},
	spec = {
		import = "plugins",
	},
	default = { version = nil },
	-- Install = { missing = true, colorscheme = { 'tokyonight', 'material' } },
	install = { missing = true, colorscheme = { "nvchad" } },
	checker = {
		enabled = true,
		notify = true,
	},
	ui = {
		border = "rounded",
		wrap = true,
		title = "Lazy UI",
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
		custom_keys = {
			["<leader>lG"] = {
				function(plugin)
					require("lazy.util").float_term({ "lazygit", "log" }, {
						cwd = plugin.dir,
					})
				end,
				desc = "Open lazygit log",
			},
			["<leader>li"] = {
				function(plugin)
					local Util = require("lazy.util")
					Util.notify(vim.inspect(plugin), {
						title = "Inspect " .. plugin.name,
						lang = "lua",
					})
				end,
				desc = "Inspect Plugin",
			},
			["<leader>lt"] = {
				function(plugin)
					require("lazy.util").float_term(nil, {
						cwd = plugin.dir,
					})
				end,
				desc = "Open terminal in plugin dir",
			},
		},
	},
	diff = {
		cmd = "diffview.nvim",
	},
	change_detection = {
		enabled = true,
		notify = true, -- Disable notifications for changes
	},
	performance = {
		rtp = {
			disable_plugins = {
				"2html_plugin",
				"tohtml",
				"matchit",
				"matchparen",
				"netrwPlugin",
				"tarPlugin",
				"zipPlugin",
				"tar",
			},
		},
	},
})

vim.keymap.set("n", "<leader>z", "<cmd>Lazy<cr>", { desc = "Lazy" })

vim.api.nvim_create_autocmd("User", {
	pattern = "VeryLazy",
	callback = function()
		require("core.keymaps")
	end,
})

for _, source in ipairs({
	"core.keymaps",
	"core.autocmds",
	"core.terminal",
	"core.options",
}) do
	local status_ok, fault = pcall(require, source)
	if not status_ok then
		vim.api.nvim_err_writeln("Failed to load " .. source .. "\n\n" .. fault)
	end
end

for _, file in ipairs(vim.fn.readdir(vim.fn.stdpath("config") .. "/lua/custom/functions", [[v:val =~ '\.lua$']])) do
	require("custom.functions." .. file:gsub("%.lua$", ""))
end

-- Neovim-remote open files from lazygit in nvim
vim.cmd([[
if has('nvim') && executable('nvr')
  let $GIT_EDITOR = "nvr -cc split --remote-wait +'set bufhidden=wipe'"
endif
]])

-- Append 'c' to shortmess to avoid showing extra completion messages
vim.opt.shortmess:append("c")

vim.cmd([[
let g:clipboard = {
            \   'name': 'WslClipboard',
            \   'copy': {
            \      '+': 'clip.exe',
            \      '*': 'clip.exe',
            \    },
            \   'paste': {
            \      '+': 'powershell.exe -NoLogo -NoProfile -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
            \      '*': 'powershell.exe -NoLogo -NoProfile -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
            \   },
            \   'cache_enabled': 0,
            \ }
]])
