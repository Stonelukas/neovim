-- Create a local alias for setting local options
local set = vim.opt_local

-- Create an autocommand that triggers on opening a terminal
vim.api.nvim_create_autocmd("TermOpen", {
	-- Create a new autocommand group for terminal settings
	group = vim.api.nvim_create_augroup("custom-term-open", {}),
	-- Define the settings to apply when a terminal opens
	callback = function()
		set.number = false
		set.relativenumber = false
		-- Set the scroll offset to zero
		set.scrolloff = 0

		vim.bo.filetype = "terminal"
	end,
})

-- Map double escape to exit terminal mode
vim.keymap.set("t", "<esc><esc>", "<c-\\><c-n>", { desc = "Exit terminal mode" })

-- Map ',st' in normal mode to open a terminal in a new window at the bottom
vim.keymap.set("n", ",st", function()
	vim.cmd.new()
	vim.cmd.wincmd("J")
	vim.api.nvim_win_set_height(0, 12)
	vim.wo.winfixheight = true
	vim.cmd.term()
end, { desc = "Open a terminal at the bottom of the screen" })

-- Configuration for the Floaterm plugin
-- Set the width and height of the floating terminal to 95% of the screen size
vim.g.floaterm_width = 0.95
vim.g.floaterm_height = 0.95

-- Key mappings for Floaterm plugin
vim.cmd([[
nnoremap   <silent>   <F7>    :FloatermNew<CR>
tnoremap   <silent>   <F7>    <C-\><C-n>:FloatermNew<CR>
nnoremap   <silent>   <F8>    :FloatermPrev<CR>
tnoremap   <silent>   <F8>    <C-\><C-n>:FloatermPrev<CR>
nnoremap   <silent>   <F9>    :FloatermNext<CR>
tnoremap   <silent>   <F9>    <C-\><C-n>:FloatermNext<CR>
nnoremap   <silent>   <F12>   :FloatermToggle<CR>
tnoremap   <silent>   <F12>   <C-\><C-n>:FloatermToggle<CR>
]])

