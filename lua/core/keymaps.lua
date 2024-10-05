local map = vim.keymap.set

local function opts(desc, expr)
    return { desc = "" .. desc, noremap = true, silent = true, nowait = true, expr = more }
end

-- Better up/down
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })
map({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })

-- Diagnostics keymaps
map("n", "<leader>e", vim.diagnostic.open_float, opts("open diagnostic in float"))

-- Executing/Sourcing
map("n", "<leader>x", "<cmd>.lua<cr>", opts("Execute the current line"))
-- TODO: jaq
map("n", "<leader>xx", "<cmd>Jaq<cr>", opts("Execute the current file"))

-- General keymaps
-- set("n", "j", "jzz", { silent = true }) -- Uncomment to center screen after moving down
-- set("n", "k", "kzz", { silent = true }) -- Uncomment to center screen after moving up
map("i", "jj", "<Esc>", opts("exit insert mode"))            -- Exit insert mode
map("t", "jj", "<C-\\><C-n>", opts("exit terminal mode"))    -- Exit terminal mode
map("t", "<ESC>", "<C-\\><C-n>", opts("exit terminal mode")) -- Exit terminal mode
map("t", "<C-h>", "<C-\\><C-n><C-w>h")
map("t", "<C-j>", "<C-\\><C-n><C-w>j")
map("t", "<C-k>", "<C-\\><C-n><C-w>k")
map("t", "<C-l>", "<C-\\><C-n><C-w>l")
-- Add undo break-points
map("i", ",", ",<c-g>u")
map("i", ".", ".<c-g>u")
map("i", ";", ";<c-g>u")
-- Paste over currently selected text without yanking it
map("v", "p", '"_dP')
map("n", "n", "nzz", opts("Go to next search result"))                 -- Center screen after going to next search result
map("n", "N", "Nzz", opts("Go to previous search result"))             -- Center screen after going to previous search result
map("n", "<C-q>", ":q<CR>", opts(" quit"))                             -- Quit the current window
map("n", "<CR>", "o<Esc>", opts("add new line"))                       -- Add a new line below the current line
map("n", "<S-Enter>", "O<Esc>", opts("add new line above"))            -- Add a new line above the current line
map("n", "<leader>sw", "<Cmd>update<CR>", opts("save file"))           -- Save the current file if modified
map("n", "<leader>sW", "<Cmd>wall<CR>", opts("save all files"))        -- Save all open files
map("n", "<leader>sq", ":wqa<CR>", opts("save and quit"))              -- Save and quit the current file
map("n", "<leader>qq", ":qa!<CR>", opts("quit without saving"))        -- Quit all without saving
map("n", "gx", ":!open <c-r><c-a><CR>", opts("open URL under cursor")) -- Open URL under cursor
map("v", "J", ":move '>+1<CR>gv=gv", opts("Move selected lines down")) -- Move selected lines down
map("v", "K", ":move '>-2<CR>gv=gv", opts("Move selected lines up"))   -- Move selected lines up
-- Keep things highlighted after moving with < and >
map("v", "<", "<gv", opts("Keep select after indenting"))
map("v", ">", ">gv", opts("Keep select after indenting"))

-- Use operator pending mode to visually select the whole buffer
-- e.g. dA = delete buffer ALL, yA = copy whole buffer ALL
map("o", "A", ":<c-u>normal! ggVG<CR>`z", opts("Select the whole buffer"))
map("v", "A", ":<c-u>normal! ggVG<CR>`z", opts("Select the whole buffer"))

-- better cursor movement
map("n", "<c-k>", "<cmd> wincmd k<CR>", opts("move window up"))
map("n", "<c-j>", "<cmd> wincmd j<CR>", opts("move window down"))
map("n", "<c-h>", "<cmd> wincmd h<CR>", opts("move window left"))
map("n", "<c-l>", "<cmd> wincmd l<CR>", opts("move window right"))

-- Tab management
map("n", "<leader>to", "<cmd>tabnew<cr>", opts("open a new tab"))
map("n", "<leader>tc", "<cmd>tabclose<cr>", opts("close a new tab"))
map("n", "<leader>tn", "<cmd>tabn<cr>", opts("next tab"))
map("n", "<leader>tp", "<cmd>tabp<cr>", opts("previous tab"))

-- nvchad tabufline
map("n", "<Tab>", function()
    require("nvchad.tabufline").next()
end, opts("Go to next buffer"))
map("n", "<S-Tab>", function()
    require("nvchad.tabufline").prev()
end, opts("Go to previous buffer"))
map("n", "<leader>bc", function()
    require("nvchad.tabufline").close_buffer()
end, opts("Close buffer"))
map("n", "<leader>ba", function()
    require("nvchad.tabufline").closeAllBufs(false)
end, opts("Close all buffer"))
map("n", "<leader>br", function()
    require("nvchad.tabufline").move_buf(1)
end, opts("Move buffer right"))
map("n", "<leader>bl", function()
    require("nvchad.tabufline").move_buf(-1)
end, opts("Move buffer left"))
for i = 1, 9, 1 do
    vim.keymap.set("n", string.format("<A-%s>", i), function()
        vim.api.nvim_set_current_buf(vim.t.bufs[i])
    end)
end

-- nvchad term
-- new terminals
map("n", "<leader>th", function()
    require("nvchad.term").new({ pos = "sp" })
end, { desc = "terminal new horizontal term" })

map("n", "<leader>tv", function()
    require("nvchad.term").new({ pos = "vsp" })
end, { desc = "terminal new vertical window" })
-- toggleable
map({ "n", "t" }, "<A-i>", function()
    require("nvchad.term").toggle({ pos = "float", id = "floatTerm" })
end, { desc = "terminal toggle floating term" })

-- nvchad rename
map("n", "grn", function()
    require("nvchad.lsp.renamer")()
end, opts("rename"))

-- TODO: fzf-lua
-- fuzzy file completion in insert mode
map("i", "<C-x><C-f>", function()
    require("fzf-lua").complete_file({
        cmd = "rg --files",
        winopts = { preview = { hidden = "nohidden" } },
    })
end, opts("Fuzzy complete file"))

map("n", "<leader>lt", function()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = 0 }), { bufnr = 0 })
end, opts("Toggle Inlay Hints"))
