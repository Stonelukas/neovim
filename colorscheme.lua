local action = require("fzf.actions").action
local fzf = require("fzf")

local function get_colorschemes()
	local colorscheme_vim_files = vim.fn.globpath(vim.o.rtp, "colors/*.vim", true, true)
	local colorschemes = {}
	for _, colorscheme_file in ipairs(colorscheme_vim_files) do
		local colorscheme = vim.fn.fnamemodify(colorscheme_file, ":t:r")
		table.insert(colorschemes, colorscheme)
	end
	return colorschemes
end

local function get_current_colorscheme()
	if vim.g.colors_name then
		return vim.g.colors_name
	else
		return "default"
	end
end

coroutine.wrap(function()
	local preview_function = action(function(args)
		if args then
			local colorscheme = args[1]
			vim.cmd("colorscheme " .. colorscheme)
		end
	end)

	local current_colorscheme = get_current_colorscheme()
	local choices = fzf(get_colorschemes(), "--preview=" .. preview_function .. " --preview-window right:0")
	if not choices then
		vim.cmd("colorscheme " .. current_colorscheme)
	else
		vim.cmd("colorscheme " .. choices[1])
	end
end)()
