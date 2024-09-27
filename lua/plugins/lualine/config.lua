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

local config = {
    options = {
        icons_enabled = true,
        --[[ theme = require("custom.transparent").theme(), ]]
        theme = "auto",
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        disabled_filetypes = {
            statusline = {},
            winbar = {},
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
            {
                require("noice").api.status.command.get(),
                cond = require("noice").api.status.command.has(),
                color = { fg = "#ff9e64" },
            },
            {
                require("noice").api.status.search.get(),
                cond = require("noice").api.status.search.has(),
                color = { fg = "#ff9e64" },
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
            -- Codeium
            {
                function()
                    if not pcall(require, "codeium") then
                        return
                    end
                    return vim.api.nvim_call_function("codeium#GetStatusString", {})

                end,
                fmt = trunc(120, 20, nil, true),
                color = { fg = colors.cyan },
            },
            {
                function()
                    return require("lsp-progress").progress({
                        max_size = 80,
                        icon = { "", align = "right" },
                    })
                end,
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
            --[[ {
                        "filename",
                        file_status = true,
                        path = 0,
                        symbols = {
                            modified = "[+]", -- Text to show when the file is modified.
                            readonly = "[-]", -- Text to show when the file is non-modifiable or readonly.
                            unnamed = "[No Name]", -- Text to show for unnamed buffers.
                            newfile = "[New]", -- Text to show for newly created file before first write
                        },
                    }, ]]
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
}

-- listen lsp-progress event and refresh lualine
vim.api.nvim_create_augroup("lualine_augroup", { clear = true })
vim.api.nvim_create_autocmd("User", {
    group = "lualine_augroup",
    pattern = "LspProgressStatusUpdated",
    callback = require("lualine").refresh,
})

-- Inserts a component in lualine_c at left section
local function ins_left(component)
    table.insert(config.sections.lualine_c, component)
end

-- Inserts a component in lualine_x ot right section
local function ins_right(component)
    table.insert(config.sections.lualine_x, component)
end

-- ins_left({
-- 	"lsp_progress",
-- 	display_components = { "lsp_client_name", { "title", "percentage", "message" } },
-- 	-- With spinner
-- 	-- display_components = { 'lsp_client_name', 'spinner', { 'title', 'percentage', 'message' }},
-- 	colors = {
-- 		percentage = colors.cyan,
-- 		title = colors.cyan,
-- 		message = colors.cyan,
-- 		spinner = colors.cyan,
-- 		lsp_client_name = colors.magenta,
-- 		use = true,
-- 	},
-- 	separators = {
-- 		component = " ",
-- 		progress = " | ",
-- 		message = { pre = "(", post = ")" },
-- 		percentage = { pre = "", post = "%% " },
-- 		title = { pre = "", post = ": " },
-- 		lsp_client_name = { pre = "[", post = "]" },
-- 		spinner = { pre = "", post = "" },
-- 	},
-- 	timer = { progress_enddelay = 500, spinner = 1000, lsp_client_name_enddelay = 1000 },
-- 	spinner_symbols = { "🌑 ", "🌒 ", "🌓 ", "🌔 ", "🌕 ", "🌖 ", "🌗 ", "🌘 " },
-- })

require("lualine").setup(config)
