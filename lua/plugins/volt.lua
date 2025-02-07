return {
	{
		"nvzone/volt",
		lazy = true,
	},
	{
		"nvzone/minty",
		cmd = {
			"Shades",
			"Huefy",
		},
		keys = {
			{
				"<leader>cp",
				function()
					require("minty.huefy").open()
				end,
				desc = "open Color Picker",
			},
		},
		opts = {
			huefy = {
				border = true,
				---@diagnostic disable-next-line: unused-local
				mappings = function(bufs) -- bufs is a table cuz 2 bufs!
					-- add your mappings here ( buffer scoped )
				end,
			},

			shades = {
				border = true,
				mappings = function(buf)
					-- add your mappings here ( buffer scoped )
					local api = require("minty.shades.api")
					vim.keymap.set("n", "<leader>os", api.save_color, { buffer = buf })
				end,
			},
		},
	},
	{
		"nvzone/menu",
		lazy = false,
		config = function()
			vim.keymap.set("n", "<C-p>", function()
				local default = {
					{
						name = "Format Buffer",
						cmd = function()
							local ok, conform = pcall(require, "conform")

							if ok then
								conform.format({ lsp_fallback = true })
							else
								vim.lsp.buf.format()
							end
						end,
						rtxt = "<leader>fm",
					},

					{
						name = "Code Actions",
						cmd = vim.lsp.buf.code_action,
						rtxt = "<leader>ca",
					},

					{ name = "separator" },

					{
						name = "  Lsp Actions",
						hl = "Exblue",
						items = "lsp",
					},

					{ name = "separator" },

					{
						name = "󰊢  Gitsigns",
						hl = "Exblue",
						items = "gitsigns",
					},

					{ name = "separator" },

					{
						name = "Edit Config",
						cmd = function()
							vim.cmd("tabnew")
							local conf = vim.fn.stdpath("config")
							vim.cmd("tcd " .. conf .. " | e init.lua")
						end,
						rtxt = "ed",
					},

					{
						name = "Copy Content",
						cmd = "%y+",
						rtxt = "<C-c>",
					},

					{
						name = "Delete Content",
						cmd = "%d",
						rtxt = "dc",
					},

					{
						name = "URL",
						cmd = function()
							local urls = require("vim.ui")._get_urls()
							-- convert "string[]" to "string"
							local url = table.concat(urls, " ")
							vim.ui.open(url)
						end,
						rtxt = "gx",
					},
					-- https://github.com

					{ name = "separator" },

					{
						name = "  Open in terminal",
						hl = "ExRed",
						cmd = function()
							local old_buf = require("menu.state").old_data.buf
							local old_bufname = vim.api.nvim_buf_get_name(old_buf)
							local old_buf_dir = vim.fn.fnamemodify(old_bufname, ":h")

							local cmd = "cd " .. old_buf_dir

							-- base46_cache var is an indicator of nvui user!
							if vim.g.base46_cache then
								require("nvchad.term").new({ cmd = cmd, pos = "sp" })
							else
								vim.cmd("enew")
								vim.fn.termopen({ vim.o.shell, "-c", cmd .. " ; " .. vim.o.shell })
							end
						end,
					},

					{ name = "separator" },

					{
						name = "  Color Picker",
						cmd = function()
							require("minty.huefy").open()
						end,
					},
				}

				local options = vim.bo.ft == "NvimTree" and "nvimtree" or default
				require("menu").open(options)
			end, { desc = "Open Menu" })

			-- mouse users + nvimtree users!
			vim.keymap.set("n", "<RightMouse>", function()
				vim.cmd.exec('"normal! \\<RightMouse>"')
				local default = {
					{
						name = "Format Buffer",
						cmd = function()
							local ok, conform = pcall(require, "conform")

							if ok then
								conform.format({ lsp_fallback = true })
							else
								vim.lsp.buf.format()
							end
						end,
						rtxt = "<leader>fm",
					},

					{
						name = "Code Actions",
						cmd = vim.lsp.buf.code_action,
						rtxt = "<leader>ca",
					},

					{ name = "separator" },

					{
						name = "  Lsp Actions",
						hl = "Exblue",
						items = "lsp",
					},

					{ name = "separator" },

					{
						name = "󰊢  Gitsigns",
						hl = "Exblue",
						items = "gitsigns",
					},

					{ name = "separator" },

					{
						name = "Edit Config",
						cmd = function()
							vim.cmd("tabnew")
							local conf = vim.fn.stdpath("config")
							vim.cmd("tcd " .. conf .. " | e init.lua")
						end,
						rtxt = "ed",
					},

					{
						name = "Copy Content",
						cmd = "%y+",
						rtxt = "<C-c>",
					},

					{
						name = "Delete Content",
						cmd = "%d",
						rtxt = "dc",
					},

					{
						name = "URL",
						cmd = function()
							local urls = require("vim.ui")._get_urls()
							-- convert "string[]" to "string"
							local url = table.concat(urls, " ")
							vim.ui.open(url)
						end,
						rtxt = "gx",
					},
					-- https://github.com
					{ name = "separator" },

					{
						name = "  Open in terminal",
						hl = "ExRed",
						cmd = function()
							local old_buf = require("menu.state").old_data.buf
							local old_bufname = vim.api.nvim_buf_get_name(old_buf)
							local old_buf_dir = vim.fn.fnamemodify(old_bufname, ":h")

							local cmd = "cd " .. old_buf_dir

							-- base46_cache var is an indicator of nvui user!
							if vim.g.base46_cache then
								require("nvchad.term").new({ cmd = cmd, pos = "sp" })
							else
								vim.cmd("enew")
								vim.fn.termopen({ vim.o.shell, "-c", cmd .. " ; " .. vim.o.shell })
							end
						end,
					},

					{ name = "separator" },

					{
						name = "  Color Picker",
						cmd = function()
							require("minty.huefy").open()
						end,
					},
				}

				local options = vim.bo.ft == "NvimTree" and "nvimtree" or default
				require("menu").open(options, { mouse = true })
			end, {})
		end,
	},
	{
		"nvchad/nvim-colorizer.lua",
		config = function()
			require("colorizer").setup({
				filetypes = { "*" },
				user_default_options = {
					RGB = true,
					RRGGBB = true,
					names = true,
					RRGGBBAA = true,
					rgb_fn = true,
					hsl_fn = true,
					css = true,
					css_fn = true,
					tailwind = true,
					mode = "virtualtext",
					always_update = true,
				},
			})
		end,
	},
	{
		"nvzone/typr",
		cmd = { "Typr" },
	},
}
