return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	dependencies = {
		"nvim-treesitter/nvim-treesitter-textobjects",
		"RRethy/nvim-treesitter-endwise",
		"nvim-treesitter/nvim-treesitter-context",
		"nvim-treesitter/nvim-treesitter-refactor",
	},
	config = function()
		local config = require("nvim-treesitter.configs")
		config.setup({
			endwise = {
				enable = true,
			},
			matchup = {
				enable = true,
			},
			ignore_install = {},
			modules = {},
			sync_install = true,
			parser_install_dir = nil,
			auto_install = true,
			ensure_installed = {
				"c",
				"lua",
				"vim",
				"vimdoc",
				"query",
				"rust",
				"toml",
				"javascript",
				"typescript",
				"tsx",
				"json",
				"markdown",
			},
			highlight = { enable = true, additional_vim_regex_highlighting = false },
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<c-space>",
					node_incremental = "<c-space>",
					scope_incremental = "<c-s>",
					node_decremental = "<M-space>",
				},
			},
			indent = { enable = true },
			rainbow = {
				enable = true,
				extended_mode = true,
				max_file_line = nil,
			},
			textobjects = {
				lsp_interop = {
					enable = true,
					border = "rounded",
					peek_definition_code = {
						["<leader>df"] = "@function.outer",
						["<leader>dF"] = "@class.outer",
					},
				},
				select = {
					enable = true,
					lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
					keymaps = {
						-- You can use the capture groups defined in textobjects.scm
						["aa"] = "@parameter.outer",
						["ia"] = "@parameter.inner",
						["af"] = "@function.outer",
						["if"] = "@function.inner",
						["ac"] = "@class.outer",
						["ic"] = "@class.inner",
					},
				},
				move = {
					enable = true,
					set_jumps = true, -- whether to set jumps in the jumplist
					goto_next_start = {
						["]m"] = "@function.outer",
						["]]"] = "@class.outer",
					},
					goto_next_end = {
						["]M"] = "@function.outer",
						["]["] = "@class.outer",
					},
					goto_previous_start = {
						["[m"] = "@function.outer",
						["[["] = "@class.outer",
					},
					goto_previous_end = {
						["[M"] = "@function.outer",
						["[]"] = "@class.outer",
					},
				},
				swap = {
					enable = true,
					swap_next = {
						["<leader>a"] = "@parameter.inner",
					},
					swap_previous = {
						["<leader>A"] = "@parameter.inner",
					},
				},
			},
			refactor = {
				highlight_definitions = {
					enable = false,
					highlight_current_scope = { enable = true },
					smart_rename = {
						enable = true,
						keymaps = {
							smart_rename = "grr",
						},
					},
					navigation = {
						enable = true,
						-- Assign keymaps to false to disable them, e.g. `goto_definition = false`.
						keymaps = {
							goto_definition = "gmd",
							list_definitions = "gmD",
							list_definitions_toc = "gO",
							goto_next_usage = "<a-*>",
							roto_previous_usage = "<a-#>",
						},
					},
					clear_on_cursor_move = true,
				},
			},
		})

		require("treesitter-context").setup({})
	end,
	{
		"lhkipp/nvim-nu",
		config = function()
			require("nu").setup({
				use_lsp_features = true,
				all_cmd_names = [[help commands | get name | str join "\n"]],
			})
		end,
	},
}
