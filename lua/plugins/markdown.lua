--   https://github.com/davidgranstrom/nvim-markdown-preview
return {
	{
		"davidgranstrom/nvim-markdown-preview",
	},
	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		build = "cd app && yarn install",
		init = function()
			-- vim.g.mkdp_filetypes = { "markdown" }
		end,
		-- ft = { "markdown" },
		config = function()
			vim.cmd([[
                let g:mkdp_auto_start = 1
                let g:mkdp_command_for_global = 1
                let g:mkdp_auto_close = 0
                let g:mkdp_echo_preview_url = 1
                let g:mkdp_combine_preview = 1
                let g:mkdp_combine_preview_auto_refresh = 1

            ]])
		end,
	},
	{
		"MeanderingProgrammer/render-markdown.nvim",
		cond = true,
        ft = { "markdown", "Avante" },
		opts = {},
		config = function()
			require("render-markdown").setup({
				preset = "obsidian",
                file_types = { "markdown", "Avante" },
				render_modes = { "n", "c", "i", "v" },
				anti_conceal = { enabled = true },
				debounce = 60,
				win_options = {
					conceallevel = {
						default = vim.api.nvim_get_option_value("conceallevel", {}),
						rendered = 1,
					},
				},
				pipe_table = {
					preset = "round",
				},
				indent = {
					enabled = true,
				},
				callout = { note = { rendered = "󰅾 Notary" } },
				checkbox = {
					position = "overlay",
					unchecked = { icon = "✘ " },
					checked = { icon = "✔ " },
					custom = { todo = { rendered = "◯ " } },
				},
				code = {
					position = "right",
					width = "block",
					right_pad = 10,
				},
				heading = {
					border = true,
					width = "block",
					left_pad = 2,
					right_pad = 4,
				},
			})
		end,
		dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.icons" }, -- if you prefer nvim-web-devicons
	},
	{
		"epwalsh/obsidian.nvim",
		version = "*", -- recommended, use latest release instead of latest commit
		lazy = true,
		ft = "markdown",
		-- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
		-- event = {
		--   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
		--   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
		--   -- refer to `:h file-pattern` for more examples
		--   "BufReadPre path/to/my-vault/*.md",
		--   "BufNewFile path/to/my-vault/*.md",
		-- },
		dependencies = {
			-- Required.
			"nvim-lua/plenary.nvim",

			-- see below for full list of optional dependencies 👇
		},
		opts = {
			workspaces = {
				{
					name = "personal",
					path = "/mnt/c/Users/lukig/OneDrive/Dokumente/Obsidian Vault/",
				},
			},
			mappings = {
				["gf"] = function()
					return require("obsidian").util.qf_passthrough()
				end,
				opts = { noremap = false, expr = true, buffer = true },
				-- Toggle check boxes
				["<leader>ch"] = {
					action = function()
						return require("obsidian").util.toggle_checkbox()
					end,
					opts = { buffer = true },
				},
				-- Smart action depending on context, either follow link or toggle checkbox.
				["<cr>"] = {
					action = function()
						return require("obsidian").util.smart_action()
					end,
					opts = { buffer = true, expr = true },
				},
			},
			follow_url_func = function(url)
				vim.fn.jobstart({ "open", url })
				-- vim.ui.open(url)
			end,
			follow_img_func = function(img)
				vim.fn.jobstart({ "open", url })
				vim.ui.open(img)
			end,
			-- Optional, set to true if you use the Obsidian Advanced URI plugin.
			-- https://github.com/Vinzent03/obsidian-advanced-uri
			use_advanced_uri = false,
			-- Optional, set to true to force ':ObsidianOpen' to bring the app to the foreground.
			open_app_foreground = true,
			attachments = {
				img_foler = "assets/",
			},
			ui = {
				enable = true,
			},

			-- see below for full list of options 👇
		},
	},
}
