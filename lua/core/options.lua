---- Interesting Options ----

-- Set incremental command to split the view when searching
vim.opt.inccommand = "split"
-- Configure the content displayed in the window bar
vim.opt.winbar = [[%=%m %f %y %r ]]
-- The following lines are commented out, but they configure the status line and winbar with more detailed information
vim.opt.laststatus = 3
-- vim.opt.statusline =
-- "▌%{toupper(mode())}▐ %F%m%r%h%w │ %2p%% %l/%L %-2v │ ts:%{&ts} sw:%{&sw} ft:%Y ff:%{&ff} │ %{&encoding}"
-- vim.o.winbar = "%{%v:lua.require'nvim-navic'.get_location()%}%=%m %f %y %r"

---- Folding ----
-- Set characters used for displaying folds
vim.opt.fillchars = {
	fold = " ",
	foldopen = "",
	foldclose = "",
	foldsep = " ",
	diff = "╱",
	eob = " ",
}
-- Enable folding by default
vim.o.foldenable = true
-- Set the fold column to 1 to show a marker on the side
vim.o.foldcolumn = "1"
-- Set the default fold level to 99 to start with all folds open
vim.o.foldlevel = 50
vim.wo.foldmethod = "expr"
vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"

---- Sessions ----
-- Configure session options to save/restore these aspects of the session
vim.opt.sessionoptions = {
	"globals",
	"folds",
	"buffers",
	"curdir",
	"tabpages",
	"winsize",
	"resize",
	"winpos",
	"terminal",
	"help",
	"winpos",
}

---- Mouse ----
-- Enable mouse support in all modes
vim.opt.mouse = "a"
-- Set the mouse model to extend, enhancing selection capabilities
vim.opt.mousemodel = "extend"
vim.opt.mousemoveevent = true

-- Search
-- Enable smart case and ignore case to improve search usability
vim.opt.smartcase = true
vim.opt.ignorecase = true
-- Disable incremental search
vim.opt.incsearch = false

-- Set the background color scheme to dark
vim.o.background = "dark"
-- Apply the 'tokyonight-storm' color scheme
vim.cmd([[colorscheme tokyonight]])
-- done in Plugin spec
-- Enable relative line numbers
vim.opt.relativenumber = true
-- Enable absolute line numbers
vim.opt.number = true
-- Keep the screen position centered when splitting
vim.o.splitkeep = "screen"
-- Set new splits to open below the current window
vim.opt.splitbelow = false
-- Set new splits to open to the right of the current window
vim.opt.splitright = true
-- Enable automatic indentation
vim.opt.autoindent = true
-- Configure backspace to behave more intuitively
vim.opt.backspace = "2"
-- Show command in the last line of the screen
vim.opt.showcmd = true
-- Automatically write buffer when switching between buffers or before certain commands
vim.opt.autowrite = true
-- Highlight the line with the cursor
vim.opt.cursorline = true
-- Set cursor line options to highlight screen line and number
vim.opt.cursorlineopt = "screenline,number"
-- Automatically read files when changed from the outside
vim.opt.autoread = true
-- Convert tabs to spaces
vim.opt.expandtab = true
-- Enable smart tab behavior
vim.opt.smarttab = true
-- Set the number of spaces a tab counts for
vim.opt.tabstop = 4
-- Set the number of spaces a tab counts for in insert mode
vim.opt.softtabstop = 4
-- Set the number of spaces to use for autoindent
vim.opt.shiftwidth = 4
-- Round indent to multiple of shiftwidth
vim.opt.shiftround = true
-- Enable true color support
vim.opt.termguicolors = true
vim.opt.cindent = true
vim.opt.swapfile = false
-- Enable smart indentation
vim.opt.smartindent = true
-- Show matching brackets when text indicator is over them
vim.opt.showmatch = true
-- Set the window title
vim.opt.title = true
-- Set the number of screen lines to keep above and below the cursor
vim.opt.scrolloff = 6
-- Highlight search results
vim.o.hlsearch = false
-- Enable break indent
vim.o.breakindent = true
-- Enable undo file
vim.opt.undofile = true
-- Set the delay for triggering the CursorHold event
vim.o.updatetime = 200
-- Enable line wrapping
vim.o.wrap = false
-- Always show the sign column
vim.opt.signcolumn = "yes"
-- Use the system clipboard for all operations
vim.opt.clipboard = "unnamedplus"
-- auto change cwd
vim.opt.autochdir = false
-- format
vim.o.formatoptions = "jcroqlnt"
-- cmdheight when 0 then no cmd until used
vim.opt.cmdheight = 0
-- NOTE: test completions with 'preview' and 'popup'
vim.opt.completeopt = "menuone,noselect,preview,popup"
vim.opt.conceallevel = 3
vim.opt.list = true
-- tranparency of popup windows
vim.opt.pumblend = 10
vim.opt.pumheight = 10

-- Configure completion options for a better experience
-- :help completeopt
-- menuone: popup even when there's only one match
-- noinsert: Do not insert text until a selection is made
-- noselect: Do not select, force to select one from the menu
-- shortness: avoid showing extra messages when using completion
-- updatetime: set updatetime for CursorHold
vim.o.shortmess = "filnxtToOFWIcC"
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
	group = highlight_group,
	pattern = "*",
})
