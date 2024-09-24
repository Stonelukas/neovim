local map = vim.keymap.set

local function opts(desc, expr)
	return { desc = "" .. desc, noremap = true, silent = true, nowait = true, expr = more}
end

-- Better up/down
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })
map({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })

-- Diagnostics keymaps
map('n', '<leader>e', vim.diagnostic.open_float, opts('open diagnostic in float'))

-- Executing/Sourcing 
map('n', '<leader>x', '<cmd>.lua<cr>', opts('Execute the current line'))
-- TODO: jaq
map('n', '<leader>xx', '<cmd>Jaq<cr>', opts('Execute the current file'))


-- General keymaps
-- set("n", "j", "jzz", { silent = true }) -- Uncomment to center screen after moving down
-- set("n", "k", "kzz", { silent = true }) -- Uncomment to center screen after moving up
map("i", "jj", "<Esc>", opts("exit insert mode" ))                      -- Exit insert mode
map("n", "n", "nzz", opts("Go to next search result" ))                 -- Center screen after going to next search result
map("n", "N", "Nzz", opts("Go to previous search result" ))             -- Center screen after going to previous search result
map("n", "<C-s>", ":w<CR>", opts("save" ))                              -- Save the current file
map("n", "<C-q>", ":q<CR>", opts(" quit" ))                             -- Quit the current window
map("n", "<CR>", "o<Esc>", opts("add new line" ))                       -- Add a new line below the current line
map("n", "<S-Enter>", "O<Esc>", opts("add new line above" ))            -- Add a new line above the current line
map("n", "<leader>sw", "<Cmd>update<CR>", opts("save file" ))            -- Save the current file if modified
map("n", "<leader>sW", "<Cmd>wall<CR>", opts("save all files" ))         -- Save all open files
map("n", "<leader>sq", ":wqa<CR>", opts("save and quit" ))             -- Save and quit the current file
map("n", "<leader>qq", ":qa!<CR>", opts("quit without saving" ))        -- Quit all without saving
map("n", "gx", ":!open <c-r><c-a><CR>", opts("open URL under cursor" )) -- Open URL under cursor
map("v", "J", ":move '>+1<CR>gv=gv", opts("Move selected lines down" )) -- Move selected lines down
map("v", "K", ":move '>-2<CR>gv=gv", opts("Move selected lines up" ))   -- Move selected lines up
-- Keep things highlighted after moving with < and >
map("v", "<", "<gv", opts("Keep select after indenting" ))
map("v", ">", ">gv", opts("Keep select after indenting" ))

-- Use operator pending mode to visually select the whole buffer
-- e.g. dA = delete buffer ALL, yA = copy whole buffer ALL
map('o', 'A', ':<c-u>normal! ggVG<CR>`z', opts('Select the whole buffer'))
map('v', 'A', ':<c-u>normal! ggVG<CR>`z', opts('Select the whole buffer'))


-- better cursor movement
map("n", "<c-k>", "<cmd> wincmd k<CR>", opts("move window up"))
map("n", "<c-j>", "<cmd> wincmd j<CR>", opts("move window down"))
map("n", "<c-h>", "<cmd> wincmd h<CR>", opts("move window left"))
map("n", "<c-l>", "<cmd> wincmd l<CR>", opts("move window right"))


-- Tab management
map('n', '<leader>to', '<cmd>tabnew<cr>', opts('open a new tab'))
map('n', '<leader>tc', '<cmd>tabclose<cr>', opts('close a new tab'))
map('n', '<leader>tn', '<cmd>tabn<cr>', opts('next tab'))
map('n', '<leader>tp', '<cmd>tabp<cr>', opts('previous tab'))



-- TODO: fzf-lua
-- fuzzy file completion in insert mode
map( 'i', '<C-x><C-f>', function()
    require('fzf-lua').complete_file {
        cmd = 'rg --files',
        winopts = { preview = { hidden = 'nohidden' } },
    }
end, opts('Fuzzy complete file'))


-- TODO: LSP
-- Toggle inlay hints 
map('n', '<leader>lt', function()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr= 0 }), { bufnr = 0 })
end, opts('Toggle Inlay Hints'))
