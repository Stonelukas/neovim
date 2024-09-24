return {
    {
        'folke/styler.nvim',
        config = function()
            require('styler').setup {
                themes = {
                    markdown = { colorscheme = 'material' },
                    help = { colorscheme = 'horizon' },
                }
            }
        end
    },
	{
		"akinsho/horizon.nvim",
		version = "*",
		priority = 1000,
		opts = {
			plugins = {
				cmp = true,
				indent_blankline = true,
				telescope = true,
				which_key = true,
				barbar = true,
				notify = true,
				symbols_outline = true,
				neo_tree = true,
				gitsigns = true,
				crates = true,
				hop = true,
				navic = true,
				quickscope = true,
				flash = true,
			},
		},
	},
	{
		"miversen33/material.nvim",
        priority = 1000,
		init = function()
			vim.g.material_style = "deep ocean"
		end,
		config = function()
			require("material").setup({
				contrast = {
					terminal = false,
					sidebars = true,
					floating_windows = false,
					cursor_line = false,
					lsp_virtual_text = false,
					non_current_windows = true,
					filetypes = {},
				},
				styles = {
					comments = { italic = true },
					strings = { bold = true },
					functions = { bold = true, undercurl = true },
					variables = {},
					operators = {},
					types = {},
				},
				plugins = {
					-- "coc",
					-- "colorful-winsep",
					-- "dap",
					-- "dashboard",
					-- "eyeliner",
					-- "fidget",
					-- "flash",
					-- "gitsigns",
					-- "harpoon",
					-- "hop",
					-- "illuminate",
					-- "indent-blankline",
					-- "lspsage",
					-- "mini"
					-- "neogit",
					-- "neotest",
					"neo-tree",
					"nvim-tree",
					-- "noice",
					-- "nvim-cmp",
					-- "nvim-navic",
					"nvim-web-devicons",
					-- "rainbow-delimiters",
					-- "sneak",
					"telescope",
					-- "trouble",
					-- "which-key",
					-- "nvim-notify",
				},
				lualine_style = "stealth", -- or default
				async_loading = true,
			})
		end,
	},
    {
        'folke/tokyonight.nvim',
        priority = 1000,
        opts = {},
        config = function()
            local tokyonight = require('tokyonight')
            tokyonight.setup {
                style = 'night',
                transparent = false,
                styles = {
					comments = { italic = true },
					strings = { bold = true },
					functions = { bold = true, undercurl = true },
					variables = { bold = true },
					operators = {},
					types = {},
                    sidebars = 'normal',
                    floats = 'transparent',
                },
                dim_inactive = true,
                lualine_bold = true,
            }
            tokyonight.load()
        end
    },
}
