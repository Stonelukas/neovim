opts = function(_, opts)
	local trouble = require("trouble")
	local symbols = trouble.statusline({
		mode = "lsp_document_symbols",
		groups = {},
		title = true,
		filter = { range = true },
		format = "{kind_icon}{symbol.name.Normal}",
	})
	table.insert(opts.section.lualine_c, {
		symbols.get,
		cond = symbols.has,
	})
end

local custom_fname = require("lualine.components.filename"):extend()
local colors = {
	yellow = "#ECBE7B",
	cyan = "#008080",
	darkblue = "#081633",
	green = "#98be65",
	orange = "#FF8800",
	violet = "#a9a1e1",
	magenta = "#c678dd",
	blue = "#51afef",
	red = "#ec5f67",
}

local function trunc(trunc_width, trunc_len, hide_width, no_ellipsis)
	return function(str)
		local win_width = vim.fn.winwidth(0)
		if hide_width and win_width < hide_width then
			return ""
		elseif trunc_width and trunc_len and win_width < trunc_width and #str > trunc_len then
			return str:sub(1, trunc_len) .. (no_ellipsis and "" or "...")
		end
		return str
	end
end

local navic = require("nvim-navic")

--[[ local config = {
	options = {
		icons_enabled = true,
		theme = require("custom.transparent").theme(),
		-- theme = "auto",
		component_separators = { left = "", right = "" },
		section_separators = { left = "", right = "" },
		disabled_filetypes = {
			statusline = {},
			winbar = { "Avante", "AvanteSelectedFiles", "AvanteInput" },
		},
		ignore_focus = {},
		always_divide_middle = true,
		globalstatus = true,
		refresh = {
			statusline = 1000,
			tabline = 1000,
			winbar = 1000,
		},
	},
	sections = {
		lualine_a = {
			{
				"mode",
				icons_enabled = true,
				-- fmt = trunc(80, 4, nil, true),
			},
			{
				function()
					return require("lsp-status").status()
				end,
				fmt = trunc(120, 20, 60),
			},
		},
		lualine_b = {
			{
				"branch",
				icon = "",
				color = { fg = colors.green },
			},
			{
				"diff",
				symbols = {
					added = " ",
					modified = " ",
					removed = " ",
				},
				color = { fg = colors.orange },
			},
			{
				"diagnostics",
				sources = { "nvim_diagnostic", "nvim_lsp" },
				sections = { "error", "warn", "info", "hint" },
				colored = true,
				always_visible = false,
			},
		},
		lualine_c = {
			{
				"windows",
				color = { fg = "#7e9cd8" },
				colored = true,
				show_filename_only = true,
				show_modified_status = true,
				filetype_names = {
					TelescopePrompt = "Telescope",
					dashboard = "Dashbord",
					packer = "Packer",
					fzf = "FZF",
					alpha = "Alpha",
				},
				use_mode_colors = true,
			},
			{
				function()
					if not pcall(require, "lsp_signature") then
						return
					end
					local sig = require("lsp_signature").status_line(vim.fn.winwidth(0))
					return sig.label .. "🐼" .. sig.hint
				end,
			},
		},
		lualine_x = {
			{
				"aerial",
				depth = -1,
				colored = true,
			},
			{
				"encoding",
				colored = true,
				fmt = trunc(120, 20, nil, true),
				color = { fg = colors.cyan },
			},
			{
				"fileformat",
			},
			{
				"filetype",
				color = { fg = colors.blue },
			},
		},
		lualine_y = {
			{
				"progress",
			},
			{
				require("lazy.status").progress,
				color = { fg = colors.green },
			},
			{
				require("lazy.status").updates,
				cond = require("lazy.status").has_updates,
				color = { fg = "#ff9e64" },
			},
		},
		lualine_z = { "location", "searchcount", "selectioncount" },
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = { "filename" },
		lualine_x = { "location" },
		lualine_y = {},
		lualine_z = {},
	},
	tabline = {},
	winbar = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = {
			{
				function()
					return navic.get_location()
				end,
				cond = function()
					return navic.is_available()
				end,
			},
		},
		lualine_x = {},
		lualine_y = {},
		lualine_z = {
			{
				"filename",
				path = 0,
			},
		},
	},
	inactive_winbar = {},
	extensions = {
		"quickfix",
		"ctrlspace",
		"fzf",
		"lazy",
		"fugitive",
		"man",
		"mason",
		"neo-tree",
		"nerdtree",
		"oil",
		"toggleterm",
	},
} ]]

-- require("lualine").setup(config)

-- Eviline config for lualine
-- Author: shadmansaleh
-- Credit: glepnir
local lualine = require("lualine")

-- Color table for highlights
-- stylua: ignore
local colors = {
  bg       = '#202328',
  fg       = '#bbc2cf',
  yellow   = '#ECBE7B',
  cyan     = '#008080',
  darkblue = '#081633',
  green    = '#98be65',
  orange   = '#FF8800',
  violet   = '#a9a1e1',
  magenta  = '#c678dd',
  blue     = '#51afef',
  red      = '#ec5f67',
}

local conditions = {
	buffer_not_empty = function()
		return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
	end,
	hide_in_width = function()
		return vim.fn.winwidth(0) > 80
	end,
	check_git_workspace = function()
		local filepath = vim.fn.expand("%:p:h")
		local gitdir = vim.fn.finddir(".git", filepath .. ";")
		return gitdir and #gitdir > 0 and #gitdir < #filepath
	end,
}

-- Config
local config = {
	options = {
		-- Disable sections and component separators
		component_separators = "",
		section_separators = "",
		disabled_filetypes = {
			statusline = {},
			winbar = { "Avante", "AvanteSelectedFiles", "AvanteInput" },
		},
		theme = {
			-- We are going to use lualine_c an lualine_x as left and
			-- right section. Both are highlighted by c theme .  So we
			-- are just setting default looks o statusline
			normal = { c = { fg = colors.fg, bg = colors.bg } },
			inactive = { c = { fg = colors.fg, bg = colors.bg } },
		},
		always_divide_middle = true,
		globalstatus = true,
		refresh = {
			statusline = 1000,
			tabline = 1000,
			winbar = 1000,
		},
	},
	sections = {
		-- these are to remove the defaults
		lualine_a = {},
		lualine_b = {},
		lualine_y = {},
		lualine_z = {},
		-- These will be filled later
		lualine_c = {},
		lualine_x = {},
	},
	inactive_sections = {
		-- these are to remove the defaults
		lualine_a = {},
		lualine_b = {},
		lualine_y = {},
		lualine_z = {},
		lualine_c = {},
		lualine_x = {},
	},
	winbar = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = {
			{
				function()
					return navic.get_location()
				end,
				cond = function()
					return navic.is_available()
				end,
			},
		},
		lualine_x = {},
		lualine_y = {},
		lualine_z = {
			{
				"filename",
				path = 0,
			},
		},
	},
}

-- Inserts a component in lualine_c at left section
local function ins_left(component)
	table.insert(config.sections.lualine_c, component)
end

-- Inserts a component in lualine_x at right section
local function ins_right(component)
	table.insert(config.sections.lualine_x, component)
end

ins_left({
	function()
		return "?"
	end,
	color = { fg = colors.blue }, -- Sets highlighting of component
	padding = { left = 0, right = 1 }, -- We don't need space before this
})

ins_left({
	-- mode component
	function()
		return "?"
	end,
	color = function()
		-- auto change color according to neovims mode
		local mode_color = {
			n = colors.red,
			i = colors.green,
			v = colors.blue,
			[""] = colors.blue,
			V = colors.blue,
			c = colors.magenta,
			no = colors.red,
			s = colors.orange,
			S = colors.orange,
			[""] = colors.orange,
			ic = colors.yellow,
			R = colors.violet,
			Rv = colors.violet,
			cv = colors.red,
			ce = colors.red,
			r = colors.cyan,
			rm = colors.cyan,
			["r?"] = colors.cyan,
			["!"] = colors.red,
			t = colors.red,
		}
		return { fg = mode_color[vim.fn.mode()] }
	end,
	padding = { right = 1 },
})

ins_left({
	-- filesize component
	"filesize",
	cond = conditions.buffer_not_empty,
})

ins_left({
	"filename",
	cond = conditions.buffer_not_empty,
	color = { fg = colors.magenta, gui = "bold" },
})

ins_left({ "location" })

ins_left({ "progress", color = { fg = colors.fg, gui = "bold" } })

ins_left({ "branch", icon = "", color = { fg = colors.violet, gui = "bold" } })
ins_left({ "diff", symbols = { added = " ", modified = " ", removed = " " }, color = { fg = colors.green } })

ins_left({
	"diagnostics",
	sources = { "nvim_diagnostic" },
	symbols = { error = "? ", warn = "? ", info = "? " },
	diagnostics_color = {
		error = { fg = colors.red },
		warn = { fg = colors.yellow },
		info = { fg = colors.cyan },
	},
})

-- Insert mid section. You can make any number of sections in neovim :)
-- for lualine it's any number greater then 2
ins_left({
	function()
		return "%="
	end,
})

ins_left({
	-- Lsp server name .
	function()
		local msg = "No Active Lsp"
		local buf_ft = vim.api.nvim_get_option_value("filetype", { buf = 0 })
		local clients = vim.lsp.get_clients()
		if next(clients) == nil then
			return msg
		end
		for _, client in ipairs(clients) do
			local filetypes = client.config.filetypes
			if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
				return client.name
			end
		end
		return msg
	end,
	icon = "? LSP:",
	color = { fg = "#ffffff", gui = "bold" },
})

-- Add components to right sections
ins_right({
	"o:encoding", -- option component same as &encoding in viml
	fmt = string.upper, -- I'm not sure why it's upper case either ;)
	cond = conditions.hide_in_width,
	color = { fg = colors.green, gui = "bold" },
})

ins_right({
	"fileformat",
	fmt = string.upper,
	icons_enabled = false, -- I think icons are cool but Eviline doesn't have them. sigh
	color = { fg = colors.green, gui = "bold" },
})

ins_right({
	"branch",
	icon = "?",
	color = { fg = colors.violet, gui = "bold" },
})

ins_right({
	"diff",
	-- Is it me or the symbol for modified us really weird
	symbols = { added = "? ", modified = "?? ", removed = "? " },
	diff_color = {
		added = { fg = colors.green },
		modified = { fg = colors.orange },
		removed = { fg = colors.red },
	},
	cond = conditions.hide_in_width,
})

ins_right({
	function()
		return "?"
	end,
	color = { fg = colors.blue },
	padding = { left = 1 },
})

-- Now don't forget to initialize lualine
lualine.setup(config)
