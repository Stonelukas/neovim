vim.g.mapleader = " "
vim.opt.autoindent = true
vim.opt.backspace = "2"
vim.opt.showcmd = true
vim.opt.laststatus = 2
vim.opt.autowrite = true
vim.opt.cursorline = true
vim.opt.autoread = true
vim.opt.expandtab = true
vim.opt.smarttab = true
vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.mouse = "a"
vim.opt.shiftround = true
vim.opt.termguicolors = true
vim.opt.cindent = true
vim.opt.smartindent = true
vim.opt.showmatch = true
vim.opt.title = true
vim.opt.scrolloff = 2
vim.opt.cursorline = true
vim.o.hlsearch = false
vim.o.breakindent = true
vim.opt.undofile = true
vim.o.updatetime = 250
vim.o.completeopt = "menu,popup"
vim.opt.termguicolors = true
vim.diagnostic.config({
	float = { border = "rounded" },
})
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Highlight on yank
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank()
	end,
	group = highlight_group,
	pattern = "*",
})
