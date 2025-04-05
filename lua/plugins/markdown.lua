--- This module configures various Markdown-related plugins for Neovim.
--- It includes settings for nvim-markdown-preview, markdown-preview.nvim, render-markdown.nvim, and obsidian.nvim.
--- Each plugin is configured with specific options and dependencies to enhance Markdown editing and previewing capabilities.
--   https://github.com/davidgranstrom/nvim-markdown-preview
return {
	{
		"ixru/nvim-markdown",
		ft = { "markdown", "Avante" },
	},
	{
		--- Configures the markdown-preview.nvim plugin.
		--- This plugin allows for live preview of Markdown files in a browser.
		--- It includes commands for toggling and stopping the preview.
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		build = "cd app && yarn install",
		-- init = function()
		--     vim.g.mkdp_filetypes = { "markdown", "Avante" }
		-- end,
		ft = { "markdown", "Avante" },
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
	}, -- For `plugins.lua` users.
	{
		"OXY2DEV/markview.nvim",
		lazy = false,

		-- For blink.cmp's completion
		-- source
		dependencies = {
			"saghen/blink.cmp",
		},
		config = function()
			local presets = require("markview.presets")
			---@param group string New highlight group.
			---@return { [string]: { hl: string } } New configuration.
			local function generic_hl(group)
				return {
					["github%.com/[%a%d%-%_%.]+%/?$"] = {
						hl = group,
					},
					["github%.com/[%a%d%-%_%.]+/[%a%d%-%_%.]+%/?$"] = {
						hl = group,
					},
					["github%.com/[%a%d%-%_%.]+/[%a%d%-%_%.]+/tree/[%a%d%-%_%.]+%/?$"] = {
						hl = group,
					},
					["github%.com/[%a%d%-%_%.]+/[%a%d%-%_%.]+/commits/[%a%d%-%_%.]+%/?$"] = {
						hl = group,
					},
					["github%.com/[%a%d%-%_%.]+/[%a%d%-%_%.]+%/releases$"] = {
						hl = group,
					},
					["github%.com/[%a%d%-%_%.]+/[%a%d%-%_%.]+%/tags$"] = {
						hl = group,
					},
					["github%.com/[%a%d%-%_%.]+/[%a%d%-%_%.]+%/issues$"] = {
						hl = group,
					},
					["github%.com/[%a%d%-%_%.]+/[%a%d%-%_%.]+%/pulls$"] = {
						hl = group,
					},
					["github%.com/[%a%d%-%_%.]+/[%a%d%-%_%.]+%/wiki$"] = {
						hl = group,
					},
				}
			end

			require("markview").setup({
				markdown = {
					headings = presets.headings.glow,
					reference_definitions = generic_hl("MarkviewPalette4Fg"),
				},
				markdown_inline = {
					hyperlinks = generic_hl("MarkviewHyperlink"),
					uri_autolinks = generic_hl("MarkviewEmail"),
				},

				typst = {
					url_links = generic_hl("MarkviewEmail"),
				},
				preview = {
					icon_previewer = "internal",
				},
			})
			require("markview.extras.checkboxes").setup({
				--- Default checkbox state(used when adding checkboxes).
				---@type string
				default = "X",

				--- Changes how checkboxes are removed.
				---@type
				---| "disable" Disables the checkbox.
				---| "checkbox" Removes the checkbox.
				---| "list_item" Removes the list item markers too.
				remove_style = "disable",

				--- Various checkbox states.
				---
				--- States are in sets to quickly change between them
				--- when there are a lot of states.
				---@type string[][]
				states = {
					{ " ", "/", "X" },
					{ "<", ">" },
					{ "?", "!", "*" },
					{ '"' },
					{ "l", "b", "i" },
					{ "S", "I" },
					{ "p", "c" },
					{ "f", "k", "w" },
					{ "u", "d" },
				},
			})
			require("markview.extras.headings").setup()
			require("markview.extras.editor").setup()
		end,
	},
	{
		--- Configures the render-markdown.nvim plugin.
		--- This plugin provides enhanced rendering options for Markdown files.
		--- It supports various render modes and customization options.
		"MeanderingProgrammer/render-markdown.nvim",
		cond = false,
		ft = { "markdown", "Avante" },
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
					sign = true,
					style = "full",
				},
				heading = {
					border = true,
					-- width = "block",
					-- left_pad = 2,
					-- right_pad = 4,
				},
			})
		end,
		dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.icons" }, -- if you prefer nvim-web-devicons
	},
	{
		--- Configures the obsidian.nvim plugin.
		--- This plugin integrates Obsidian note-taking features into Neovim.
		--- It supports workspaces, custom mappings, and advanced URI handling.
		"epwalsh/obsidian.nvim",
		version = "*", -- recommended, use latest release instead of latest commit
		lazy = true,
		ft = { "markdown", "Avante" },
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
			follow_img_func = function(img, url)
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
