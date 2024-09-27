local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- General
local general = augroup("General", { clear = false })
-- Disable automatic commenting of new lines when entering a buffer
autocmd("BufEnter", {
	group = general,
	pattern = "",
	command = "set fo-=c fo-=r fo-=o",
})

-- close some filetypes with <q>
autocmd("FileType", {
	group = general,
	pattern = {
		"OverseerForm",
		"OverseerList",
		"fugitive",
		"git",
		"lspinfo",
		"man",
		"toggleterm",
		"vim",
		"PlenaryTestPopup",
		"help",
		"lspinfo",
		"notify",
		"qf",
		"spectre_panel",
		"startuptime",
		"tsplayground",
		"neotest-output",
		"checkhealth",
		"neotest-summary",
		"neotest-output-panel",
		"dbout",
		"gitsigns.blame",
		"TelescopePrompt",
	},
	callback = function(event)
		vim.bo[event.buf].buflisted = false
		vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
	end,
})

-- wrap and check for spell in text filetypes
autocmd("FileType", {
	group = general,
	pattern = { "*.txt", "*.tex", "*.typ", "gitcommit", },
	callback = function()
		vim.opt_local.wrap = true
		vim.opt_local.spell = true
	end,
})

-- Check if we need to reload the file when it changed
autocmd("FocusGained", { command = "checktime" })

-- show cursor line only in active window
autocmd({ "InsertLeave", "WinEnter" }, {
	callback = function()
		local ok, cl = pcall(vim.api.nvim_win_get_var, 0, "auto-cursorline")
		if ok and cl then
			vim.wo.cursorline = true
			vim.api.nvim_win_del_var(0, "auto-cursorline")
		end
	end,
})
autocmd({ "InsertEnter", "WinLeave" }, {
	callback = function()
		local cl = vim.wo.cursorline
		if cl then
			vim.api.nvim_win_set_var(0, "auto-cursorline", cl)
			vim.wo.cursorline = false
		end
	end,
})

-- Go to last loc when opening a buffer
autocmd("BufReadPre", {
	pattern = "*",
	callback = function()
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "<buffer>",
			once = true,
			callback = function()
				vim.cmd(
					[[if &ft !~# 'commit\|rebase' && line("'\"") > 1 && line("'\"") <= line("$") | exe 'normal! g`"' | endif]]
				)
			end,
		})
	end,
})

autocmd("FileType", {
	group = general,
	pattern = { "help", "man" },
	command = "wincmd L",
})

-- Plugins
local function get_session_name()
	local name = vim.fn.getcwd()
	local branch = vim.trim(vim.fn.system("git branch --show-current"))
	if vim.v.shell_error == 0 then
		return name .. branch
	else
		return name
	end
end
-- SESSIONS
local Sessions = augroup("Plugins", { clear = false })
autocmd("VimLeavePre", {
	group = Sessions,
	callback = function()
		-- Save these to a different directory, so our manual sessions don't get polluted
		require("resession").save(vim.fn.getcwd(), { notify = true })
	end,
})

-- autosave and open based on directories
autocmd("VimEnter", {
	group = Sessions,
	callback = function()
		-- Only load the session if nvim was started with no args
		if vim.fn.argc(-1) == 0 then
			require("resession").load(vim.fn.getcwd(), { silence_errors = true })
		end
	end,
	nested = true,
})

-- autosave and open based on git
-- autocmd('VimEnter', {
-- 	callback = function()
-- 		-- Only load the session if nvim was started with no args
-- 		if vim.fn.argc(-1) == 0 then
-- 			-- Save these to a different directory, so our manual sessions don't get polluted
-- 			require('resession').load(get_session_name(), { dir = 'dirsession', silence_errors = true })
-- 		end
-- 	end,
-- })
-- autocmd('VimLeavePre', {
-- 	callback = function()
-- 		require('resession').save(get_session_name(), { dir = 'dirsession', notify = false })
-- 	end,
-- })

-- Neoclip
local Neoclip = augroup("Plugins", { clear = false })
autocmd("VimLeavePre", {
	group = Neoclip,
	callback = function()
		require("neoclip").db_push()
	end,
})

autocmd("VimEnter", {
	group = Neoclip,
	callback = function()
		require("neoclip").db_pull()
	end,
})
