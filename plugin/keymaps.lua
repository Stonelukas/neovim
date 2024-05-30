local set = vim.keymap.set

vim.keymap.set({ "i" }, "<C-x><C-f>", function()
	require("fzf-lua").complete_file({
		cmd = "rg --files",
		winopts = { preview = { hidden = "nohidden" } },
	})
end, { silent = true, desc = "Fuzzy complete file" })

set("n", "<C-s>", ":w<CR>", { desc = "save" })
set("n", "<C-q>", ":q<CR>", { desc = " quit" })
set("n", "<CR>", "o<Esc>", { desc = "add new line" })
set("n", "<S-Enter>", "O<Esc>", { desc = "add new line above" })
set("n", "<leader>e", vim.diagnostic.open_float, { desc = "open diagnostic in float" })
set("n", "<leader>x", "<cmd>.lua<CR>", { desc = "Execute the current line" })
set("n", "<leader>xx", "<cmd>source %<CR>", { desc = "Execute the current file" })

-- General keymaps
set("n", "<leader {>wq }", ":wq<CR>", { desc = "save and quit" }) -- save and quit
set("n", "<leader>qq", ":q!<CR>", { desc = "quit without saving" }) -- quit without saving
set("n", "<leader>ww", ":w<CR>", { desc = "save" }) -- save
set("n", "gx", ":!open <c-r><c-a><CR>", { desc = "open URL under cursor" }) -- open URL under cursor

-- Split window management
set("n", "<leader>sv", "<C-w>v", { desc = "split window vertically" }) -- split window vertically
set("n", "<leader>sh", "<C-w>s", { desc = "split window horizontally" }) -- split window horizontally
set("n", "<leader>se", "<C-w>=", { desc = "make split windows equal width" }) -- make split windows equal width
set("n", "<leader>sx", ":close<CR>", { desc = "close split window" }) -- close split window
set("n", "<leader>sj", "<C-w>-", { desc = "make split window height shorter" }) -- make split window height shorter
set("n", "<leader>sk", "<C-w>+", { desc = "make split windows height taller" }) -- make split windows height taller
set("n", "<leader>sl", "<C-w>>5", { desc = "make split windows width bigger" }) -- make split windows width bigger
set("n", "<leader>sh", "<C-w><5", { desc = "make split windows width smaller" }) -- make split windows width smaller

-- Tab management
set("n", "<leader>to", ":tabnew<CR>", { desc = "open a new tab" }) -- open a new tab
set("n", "<leader>tx", ":tabclose<CR>", { desc = "close a tab" }) -- close a tab
set("n", "<leader>tn", ":tabn<CR>", { desc = "next tab" }) -- next tab
set("n", "<leader>tp", ":tabp<CR>", { desc = "previous tab" }) -- previous tab

-- Move to previous/next
set("n", "<S-Tab>", "<Cmd>BufferPrevious<CR>", { desc = "Move to previous Buffer" })
set("n", "<Tab>", "<Cmd>BufferNext<CR>", { desc = "Move to next Buffer" })
-- Re-order to previous/next
set("n", "<A-<>", "<Cmd>BufferMovePrevious<CR>", { desc = "Move Buffer to the left" })
set("n", "<A->>", "<Cmd>BufferMoveNext<CR>", { desc = "Move Buffer to the right" })
-- Goto buffer in position...
set("n", "<A-1>", "<Cmd>BufferGoto 1<CR>", { desc = "Move to Buffer on Position 1" })
set("n", "<A-2>", "<Cmd>BufferGoto 2<CR>", { desc = "Move to Buffer on Position 2" })
set("n", "<A-3>", "<Cmd>BufferGoto 3<CR>", { desc = "Move to Buffer on Position 3" })
set("n", "<A-4>", "<Cmd>BufferGoto 4<CR>", { desc = "Move to Buffer on Position 4" })
set("n", "<A-5>", "<Cmd>BufferGoto 5<CR>", { desc = "Move to Buffer on Position 5" })
set("n", "<A-6>", "<Cmd>BufferGoto 6<CR>", { desc = "Move to Buffer on Position 6" })
set("n", "<A-7>", "<Cmd>BufferGoto 7<CR>", { desc = "Move to Buffer on Position 7" })
set("n", "<A-8>", "<Cmd>BufferGoto 8<CR>", { desc = "Move to Buffer on Position 8" })
set("n", "<A-9>", "<Cmd>BufferGoto 9<CR>", { desc = "Move to Buffer on Position 9" })
set("n", "<A-0>", "<Cmd>BufferLast<CR>", { desc = "Move to the last Buffer" })
-- Pin/unpin buffer
set("n", "<A-p>", "<Cmd>BufferPin<CR>", { desc = "Pin current Buffer" })
-- Close buffer
set("n", "<A-c>", "<Cmd>BufferClose<CR>", { desc = "Close current Buffer" })
-- Wipeout buffer
--                 :BufferWipeout
-- Close commands
--                 :BufferCloseAllButCurrent
--                 :BufferCloseAllButPinned
--                 :BufferCloseAllButCurrentOrPinned
--                 :BufferCloseBuffersLeft
--                 :BufferCloseBuffersRight
-- Sort automatically by...
set("n", "<Space>bb", "<Cmd>BufferOrderByBufferNumber<CR>", { desc = "Order Buffer by Buffer Number" })
set("n", "<Space>bn", "<Cmd>BufferOrderByName<CR>", { desc = "Order Buffer by Name" })
set("n", "<Space>bd", "<Cmd>BufferOrderByDirectory<CR>", { desc = "Order Buffer by Directory" })
set("n", "<Space>bl", "<Cmd>BufferOrderByLanguage<CR>", { desc = "Order Buffer by Language" })
set("n", "<Space>bw", "<Cmd>BufferOrderByWindowNumber<CR>", { desc = "Order Buffer by Window Number" })

set("n", "<leader>tt", function()
	vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = 0 }), { bufnr = 0 })
end, { desc = "Toggle Inlay hints" })
