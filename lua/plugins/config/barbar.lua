local map = vim.keymap.set
-- Buffer navigation keymaps
map("n", "<S-Tab>", "<Cmd>BufferPrevious<CR>", { desc = "Move to previous Buffer" })   -- Move to the previous buffer
map("n", "<Tab>", "<Cmd>BufferNext<CR>", { desc = "Move to next Buffer" })             -- Move to the next buffer
-- Re-order buffers
map("n", "<A-<>", "<Cmd>BufferMovePrevious<CR>", { desc = "Move Buffer to the left" }) -- Move buffer to the left
map("n", "<A->>", "<Cmd>BufferMoveNext<CR>", { desc = "Move Buffer to the right" })    -- Move buffer to the right
-- Goto buffer in specific position
map("n", "<A-1>", "<Cmd>BufferGoto 1<CR>", { desc = "Move to Buffer on Position 1" })  -- Move to buffer in position 1
map("n", "<A-2>", "<Cmd>BufferGoto 2<CR>", { desc = "Move to Buffer on Position 2" })  -- Move to buffer in position 2
map("n", "<A-3>", "<Cmd>BufferGoto 3<CR>", { desc = "Move to Buffer on Position 3" })  -- Move to buffer in position 3
map("n", "<A-4>", "<Cmd>BufferGoto 4<CR>", { desc = "Move to Buffer on Position 4" })  -- Move to buffer in position 4
map("n", "<A-5>", "<Cmd>BufferGoto 5<CR>", { desc = "Move to Buffer on Position 5" })  -- Move to buffer in position 5
map("n", "<A-6>", "<Cmd>BufferGoto 6<CR>", { desc = "Move to Buffer on Position 6" })  -- Move to buffer in position 6
map("n", "<A-7>", "<Cmd>BufferGoto 7<CR>", { desc = "Move to Buffer on Position 7" })  -- Move to buffer in position 7
map("n", "<A-8>", "<Cmd>BufferGoto 8<CR>", { desc = "Move to Buffer on Position 8" })  -- Move to buffer in position 8
map("n", "<A-9>", "<Cmd>BufferGoto 9<CR>", { desc = "Move to Buffer on Position 9" })  -- Move to buffer in position 9
map("n", "<A-0>", "<Cmd>BufferLast<CR>", { desc = "Move to the last Buffer" })         -- Move to the last buffer
-- Pin/unpin buffer
map("n", "<A-p>", "<Cmd>BufferPin<CR>", { desc = "Pin current Buffer" })               -- Pin the current buffer
-- Close buffer
map("n", "<A-c>", "<Cmd>BufferClose<CR>", { desc = "Close current Buffer" })           -- Close the current buffer
-- Wipeout buffer
--                 :BufferWipeout -- Wipeout buffer command
-- Close commands
--                 :BufferCloseAllButCurrent -- Close all buffers except the current one
--                 :BufferCloseAllButPinned -- Close all buffers except pinned ones
--                 :BufferCloseAllButCurrentOrPinned -- Close all buffers except the current or pinned ones
--                 :BufferCloseBuffersLeft -- Close all buffers to the left
--                 :BufferCloseBuffersRight -- Close all buffers to the right
-- Sort buffers automatically by...
map("n", "<Space>bb", "<Cmd>BufferOrderByBufferNumber<CR>", { desc = "Order Buffer by Buffer Number" }) -- Order buffers by buffer number
map("n", "<Space>bn", "<Cmd>BufferOrderByName<CR>", { desc = "Order Buffer by Name" })                  -- Order buffers by name
map("n", "<Space>bd", "<Cmd>BufferOrderByDirectory<CR>", { desc = "Order Buffer by Directory" })        -- Order buffers by directory
map("n", "<Space>bl", "<Cmd>BufferOrderByLanguage<CR>", { desc = "Order Buffer by Language" })          -- Order buffers by language
map("n", "<Space>bw", "<Cmd>BufferOrderByWindowNumber<CR>", { desc = "Order Buffer by Window Number" }) -- Order buffers by window number
