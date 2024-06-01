---- Interesting Options ----

vim.opt.inccommand = "split"
vim.opt.winbar = [[%=%m %f %y %r ]]

---- Folding ----
vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
vim.o.foldenable = true
vim.o.foldcolumn = "1"
vim.o.foldlevel = 99

-- Search
vim.opt.smartcase = true
vim.opt.ignorecase = true
vim.opt.incsearch = true

vim.opt.relativenumber = true
vim.opt.number = true
vim.o.splitkeep = "screen"
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.autoindent = true
vim.opt.backspace = "2"
vim.opt.showcmd = true
vim.opt.autowrite = true
vim.opt.cursorline = true
vim.opt.autoread = true
vim.opt.expandtab = true
vim.opt.smarttab = true
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
vim.o.hlsearch = true
vim.o.breakindent = true
vim.opt.undofile = true
vim.o.updatetime = 250
vim.opt.termguicolors = true
vim.o.wrap = true
vim.opt.signcolumn = "yes"
vim.opt.clipboard = "unnamedplus"

--Set completeopt to have a better completion experience
-- :help completeopt
-- menuone: popup even when there's only one match
-- noinsert: Do not insert text until a selection is made
-- noselect: Do not select, force to select one from the menu
-- shortness: avoid showing extra messages when using completion
-- updatetime: set updatetime for CursorHold
vim.opt.shortmess = vim.opt.shortmess + { c = true }
vim.api.nvim_set_option_value("updatetime", 300, {})

-- Fixed column for diagnostics to appear
-- Show autodiagnostic popup on cursor hover_range
-- Goto previous / next diagnostic warning / error
-- Show inlay_hints more frequently
-- vim.cmd([[
-- set signcolumn=yes
-- autocmd CursorHold * lua vim.diagnostic.open_float(nil, { focusable = false })
-- ]])

-- Highlight on yank
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank()
	end,
	group = highlight_group,
	pattern = "*",
})
