local map = vim.keymap.set

local function opts(desc)
	return { desc = "" .. desc, noremap = true, silent = true, nowait = true }
end

map("n", "<c-k>", "<cmd> wincmd k<CR>", opts("move window up"))
map("n", "<c-j>", "<cmd> wincmd j<CR>", opts("move window down"))
map("n", "<c-h>", "<cmd> wincmd h<CR>", opts("move window left"))
map("n", "<c-l>", "<cmd> wincmd l<CR>", opts("move window right"))

-- Visual indent
map("v", "<", "<gv", opts('better indenting'))
map("v", ">", ">gv", opts('better indenting'))
