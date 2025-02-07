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
				"markdown_inline",
				"latex",
				"bash",
				"git_config",
				"git_rebase",
				"gitattributes",
				"gitcommit",
				"gitignore",
			},
			highlight = { enable = true, additional_vim_regex_highlighting = true },
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
						-- you can use the capture groups defined in textobjects.scm
						["af"] = { query = "@function.outer", desc = "select outer part of a function" },
						["if"] = { query = "@function.inner", desc = "select inner part of a function" },
						["ac"] = { query = "@class.outer", desc = "select outer part of a class region" },
						-- you can optionally set descriptions to the mappings (used in the desc parameter of
						-- nvim_buf_set_keymap) which plugins like which-key display
						["ic"] = { query = "@class.inner", desc = "select inner part of a class region" },
						-- you can also use captures from other query groups like `locals.scm`
						["as"] = { query = "@scope", query_group = "locals", desc = "select language scope" },
					},
					selection_modes = {
						["@parameter.outer"] = "v", -- charwise
						["@function.outer"] = "v", -- linewise
						["@parameter.outer"] = "<c-v>", -- blockwise
					},
					include_surrounding_whitespace = true,
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
					enable = true,
					clear_on_cursor_move = true,
				},
				highlight_current_scope = { enable = false },
				smart_rename = {
					enable = true,
					keymaps = {
						smart_rename = "grr",
					},
				},
				navigation = {
					enable = true,
					keymaps = {
						goto_definition = "gnd",
						list_definition = "gnd",
						list_definitions_toc = "go",
						goto_next_usage = "<a-*>",
						goto_previous_usage = "<a-#>",
					},
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
