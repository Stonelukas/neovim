local set = vim.keymap.set

-- Set a keymap for insert mode to trigger fuzzy file completion using fzf-lua
set({ "i" }, "<C-x><C-f>", function()
    require("fzf-lua").complete_file({
        cmd = "rg --files",                        -- Use ripgrep to list files
        winopts = { preview = { hidden = "nohidden" } }, -- Window options for preview
    })
end, { silent = true, desc = "Fuzzy complete file" })

-- Diagnostic keymap
set("n", "<leader>e", vim.diagnostic.open_float, { desc = "open diagnostic in float" })

-- Executing/Sourcing keymaps
set("n", "<leader>x", "<cmd>.lua<CR>", { desc = "Execute the current line" })  -- Execute the current line as Lua code
set("n", "<leader>xx", "<cmd>Jaq <CR>", { desc = "Execute the current file" }) -- Source the current file

-- General keymaps
-- set("n", "j", "jzz", { silent = true }) -- Uncomment to center screen after moving down
-- set("n", "k", "kzz", { silent = true }) -- Uncomment to center screen after moving up
set("i", "jj", "<Esc>", { desc = "exit insert mode" })                      -- Exit insert mode
set("n", "n", "nzz", { desc = "Go to next search result" })                 -- Center screen after going to next search result
set("n", "N", "Nzz", { desc = "Go to previous search result" })             -- Center screen after going to previous search result
set("n", "<C-s>", ":w<CR>", { desc = "save" })                              -- Save the current file
set("n", "<C-q>", ":q<CR>", { desc = " quit" })                             -- Quit the current window
set("n", "<CR>", "o<Esc>", { desc = "add new line" })                       -- Add a new line below the current line
set("n", "<S-Enter>", "O<Esc>", { desc = "add new line above" })            -- Add a new line above the current line
set("n", "<leader>w", "<Cmd>update<CR>", { desc = "save file" })            -- Save the current file if modified
set("n", "<leader>W", "<Cmd>wall<CR>", { desc = "save all files" })         -- Save all open files
set("n", "<leader>wq }", ":wq<CR>", { desc = "save and quit" })             -- Save and quit the current file
set("n", "<leader>qq", ":qa!<CR>", { desc = "quit without saving" })        -- Quit all without saving
set("n", "gx", ":!open <c-r><c-a><CR>", { desc = "open URL under cursor" }) -- Open URL under cursor
set("v", "J", ":move '>+1<CR>gv=gv", { desc = "Move selected lines down" }) -- Move selected lines down
set("v", "K", ":move '>-2<CR>gv=gv", { desc = "Move selected lines up" })   -- Move selected lines up
-- Keep things highlighted after moving with < and >
set("v", "<", "<gv", { desc = "Keep select after indenting" })
set("v", ">", ">gv", { desc = "Keep select after indenting" })

-- Use operator pending mode to visually select the whole buffer
-- e.g. dA = delete buffer ALL, yA = copy whole buffer ALL
set("o", "A", ":<C-u>normal! mggVG<CR>`z", { desc = "Select the whole buffer" }) -- Select the whole buffer in operator pending mode
set("x", "A", ":<C-u>normal! ggVG<CR>", { desc = "Select the whole buffer" })    -- Select the whole buffer in visual mode

-- Split window management keymaps
set("n", "<leader>sV", "<C-w>v", { desc = "split window vertically" })           -- Split window vertically
set("n", "<leader>sH", "<C-w>s", { desc = "split window horizontally" })         -- Split window horizontally
set("n", "<leader>se", "<C-w>=", { desc = "make split windows equal width" })    -- Make split windows equal width
set("n", "<leader>sx", ":close<CR>", { desc = "close split window" })            -- Close split window
set("n", "<leader>sj", "<C-w>-", { desc = "make split window height shorter" })  -- Make split window height shorter
set("n", "<leader>sk", "<C-w>+", { desc = "make split windows height taller" })  -- Make split window height taller
set("n", "<leader>sl", "<C-w>>5", { desc = "make split windows width bigger" })  -- Make split window width bigger
set("n", "<leader>sh", "<C-w><5", { desc = "make split windows width smaller" }) -- Make split window width smaller

-- Tab management keymaps
set("n", "<leader>to", ":tabnew<CR>", { desc = "open a new tab" }) -- Open a new tab
set("n", "<leader>tx", ":tabclose<CR>", { desc = "close a tab" })  -- Close the current tab
set("n", "<leader>tn", ":tabn<CR>", { desc = "next tab" })         -- Move to the next tab
set("n", "<leader>tp", ":tabp<CR>", { desc = "previous tab" })     -- Move to the previous tab

-- Buffer navigation keymaps
set("n", "<S-Tab>", "<Cmd>BufferPrevious<CR>", { desc = "Move to previous Buffer" })   -- Move to the previous buffer
set("n", "<Tab>", "<Cmd>BufferNext<CR>", { desc = "Move to next Buffer" })             -- Move to the next buffer
-- Re-order buffers
set("n", "<A-<>", "<Cmd>BufferMovePrevious<CR>", { desc = "Move Buffer to the left" }) -- Move buffer to the left
set("n", "<A->>", "<Cmd>BufferMoveNext<CR>", { desc = "Move Buffer to the right" })    -- Move buffer to the right
-- Goto buffer in specific position
set("n", "<A-1>", "<Cmd>BufferGoto 1<CR>", { desc = "Move to Buffer on Position 1" })  -- Move to buffer in position 1
set("n", "<A-2>", "<Cmd>BufferGoto 2<CR>", { desc = "Move to Buffer on Position 2" })  -- Move to buffer in position 2
set("n", "<A-3>", "<Cmd>BufferGoto 3<CR>", { desc = "Move to Buffer on Position 3" })  -- Move to buffer in position 3
set("n", "<A-4>", "<Cmd>BufferGoto 4<CR>", { desc = "Move to Buffer on Position 4" })  -- Move to buffer in position 4
set("n", "<A-5>", "<Cmd>BufferGoto 5<CR>", { desc = "Move to Buffer on Position 5" })  -- Move to buffer in position 5
set("n", "<A-6>", "<Cmd>BufferGoto 6<CR>", { desc = "Move to Buffer on Position 6" })  -- Move to buffer in position 6
set("n", "<A-7>", "<Cmd>BufferGoto 7<CR>", { desc = "Move to Buffer on Position 7" })  -- Move to buffer in position 7
set("n", "<A-8>", "<Cmd>BufferGoto 8<CR>", { desc = "Move to Buffer on Position 8" })  -- Move to buffer in position 8
set("n", "<A-9>", "<Cmd>BufferGoto 9<CR>", { desc = "Move to Buffer on Position 9" })  -- Move to buffer in position 9
set("n", "<A-0>", "<Cmd>BufferLast<CR>", { desc = "Move to the last Buffer" })         -- Move to the last buffer
-- Pin/unpin buffer
set("n", "<A-p>", "<Cmd>BufferPin<CR>", { desc = "Pin current Buffer" })               -- Pin the current buffer
-- Close buffer
set("n", "<A-c>", "<Cmd>BufferClose<CR>", { desc = "Close current Buffer" })           -- Close the current buffer
-- Wipeout buffer
--                 :BufferWipeout -- Wipeout buffer command
-- Close commands
--                 :BufferCloseAllButCurrent -- Close all buffers except the current one
--                 :BufferCloseAllButPinned -- Close all buffers except pinned ones
--                 :BufferCloseAllButCurrentOrPinned -- Close all buffers except the current or pinned ones
--                 :BufferCloseBuffersLeft -- Close all buffers to the left
--                 :BufferCloseBuffersRight -- Close all buffers to the right
-- Sort buffers automatically by...
set("n", "<Space>bb", "<Cmd>BufferOrderByBufferNumber<CR>", { desc = "Order Buffer by Buffer Number" }) -- Order buffers by buffer number
set("n", "<Space>bn", "<Cmd>BufferOrderByName<CR>", { desc = "Order Buffer by Name" })                  -- Order buffers by name
set("n", "<Space>bd", "<Cmd>BufferOrderByDirectory<CR>", { desc = "Order Buffer by Directory" })        -- Order buffers by directory
set("n", "<Space>bl", "<Cmd>BufferOrderByLanguage<CR>", { desc = "Order Buffer by Language" })          -- Order buffers by language
set("n", "<Space>bw", "<Cmd>BufferOrderByWindowNumber<CR>", { desc = "Order Buffer by Window Number" }) -- Order buffers by window number

-- Noice plugin keymap
set("n", "<leader>nn", "<Cmd>Noice dismiss<CR>", { desc = "Disable Noice" }) -- Dismiss Noice notifications

-- Toggle inlay hints for LSP
set("n", "<leader>tt", function()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = 0 }), { bufnr = 0 })
end, { desc = "Toggle Inlay hints" })
