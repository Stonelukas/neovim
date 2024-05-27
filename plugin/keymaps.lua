local set = vim.keymap.set

set("n", "<C-s>", ":w<CR>", { desc = "save" })
set("n", "<C-q>", ":q<CR>", { desc = " quit" })
set("n", "<CR>", "o<Esc>", { desc = "add new line" })
set("n", "<S-Enter>", "O<Esc>", { desc = "add new line above" })
set("n", "<leader>e", vim.diagnostic.open_float, { desc = "open diagnostic in float" })

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
set("n", "<A-,>", "<Cmd>BufferPrevious<CR>", {})
set("n", "<A-.>", "<Cmd>BufferNext<CR>", {})
-- Re-order to previous/next
set("n", "<A-<>", "<Cmd>BufferMovePrevious<CR>", {})
set("n", "<A->>", "<Cmd>BufferMoveNext<CR>", {})
-- Goto buffer in position...
set("n", "<A-1>", "<Cmd>BufferGoto 1<CR>", {})
set("n", "<A-2>", "<Cmd>BufferGoto 2<CR>", {})
set("n", "<A-3>", "<Cmd>BufferGoto 3<CR>", {})
set("n", "<A-4>", "<Cmd>BufferGoto 4<CR>", {})
set("n", "<A-5>", "<Cmd>BufferGoto 5<CR>", {})
set("n", "<A-6>", "<Cmd>BufferGoto 6<CR>", {})
set("n", "<A-7>", "<Cmd>BufferGoto 7<CR>", {})
set("n", "<A-8>", "<Cmd>BufferGoto 8<CR>", {})
set("n", "<A-9>", "<Cmd>BufferGoto 9<CR>", {})
set("n", "<A-0>", "<Cmd>BufferLast<CR>", {})
-- Pin/unpin buffer
set("n", "<A-p>", "<Cmd>BufferPin<CR>", {})
-- Close buffer
set("n", "<A-c>", "<Cmd>BufferClose<CR>", {})
-- Wipeout buffer
--                 :BufferWipeout
-- Close commands
--                 :BufferCloseAllButCurrent
--                 :BufferCloseAllButPinned
--                 :BufferCloseAllButCurrentOrPinned
--                 :BufferCloseBuffersLeft
--                 :BufferCloseBuffersRight
-- Magic buffer-picking mode
set("n", "<leader>bp", "<Cmd>BufferPick<CR>", {})
-- Sort automatically by...
set("n", "<Space>bb", "<Cmd>BufferOrderByBufferNumber<CR>", {})
set("n", "<Space>bn", "<Cmd>BufferOrderByName<CR>", {})
set("n", "<Space>bd", "<Cmd>BufferOrderByDirectory<CR>", {})
set("n", "<Space>bl", "<Cmd>BufferOrderByLanguage<CR>", {})
set("n", "<Space>bw", "<Cmd>BufferOrderByWindowNumber<CR>", {})
