return {
	{
		'prochri/telescope-all-recent.nvim',
		config = function()
			require('telescope-all-recent').setup {}
		end,
	},
	{
		'otavioschwanck/telescope-cmdline-word.nvim',
		opts = {
			add_mappings = true,
		},
	},
	{
		'princejoogie/dir-telescope.nvim',
		config = function()
			require('dir-telescope').setup {
				hidden = true,
				no_ignore = false,
				show_preview = true,
				follow_symlinks = false,
			}
		end,
	},
    {
        'adoyle-h/ad-telescope-extensions.nvim',
        config = function()
            require('ad-telescope-extensions').setup {
                enable = { 
                'changes', 
                'colors', 
                'env', 
                'floaterm', 
                'lsp_document_symbols_filter', 
                'lsp_dynamic_workspace_symbols_filter', 
                'lsp_workspace_symbols_filter',
                'message',
                'packpath',
                'rtp',
                'scriptnames',
                'time',
                'zk',
                },
            }
        end
    },
	{
		'nvim-telescope/telescope.nvim',
		branch = 'master',
		dependencies = {
			{
				'nvim-telescope/telescope-fzf-native.nvim',
				build = 'make',
			},
			'brookhong/telescope-pathogen.nvim',
			'nvim-telescope/telescope-github.nvim',
			'nvim-telescope/telescope-symbols.nvim',
			'cljoly/telescope-repo.nvim',
			'nvim-telescope/telescope-node-modules.nvim',
			'crispgm/telescope-heading.nvim',
			'xiyaowong/telescope-emoji.nvim',
			'sshelll/telescope-switch.nvim',
			'LinArcX/telescope-scriptnames.nvim',
            'debugloop/telescope-undo.nvim',
            'lpoto/telescope-docker.nvim',
            'lpoto/telescope-tasks.nvim',
            'OliverChao/telescope-picker-list.nvim',
            'jonarrien/telescope-cmdline.nvim',
            'catgoose/telescope-helpgrep.nvim',
            'tsakirist/telescope-lazy.nvim',
            'polirritmico/telescope-lazy-plugins.nvim',
            'scottmckendry/telescope-resession.nvim',
		},
		opts = {},
		config = function()
			-- Configuration
			require 'plugins.config.telescope'

			local function opts(desc)
				return { desc = '' .. desc, noremap = true, silent = true, nowait = true }
			end
			local builtin = require 'telescope.builtin'
			local map = vim.keymap.set

			-- Extension
			-- pathogen
			require('telescope').load_extension 'pathogen'

			-- Github CLI
			require('telescope').load_extension 'gh'

			-- Repo
			require('telescope').load_extension 'repo'

			-- Node Modules
			require('telescope').load_extension 'node_modules'

			-- Headings
			require('telescope').load_extension 'heading'

			-- Emojis
			require('telescope').load_extension 'emoji'

			-- File Switcher
			require('telescope').load_extension 'switch'
			map('n', '<leader>fs', require('telescope').extensions.switch.switch, opts 'Switch to a Project file')
			map('n', '<leader>fs', require('telescope').extensions.switch.switch, opts 'Switch to a Project file')
			map('n', '<leader>fs', require('telescope').extensions.switch.switch, opts 'Switch to a Project file')

			-- Neoclip and Macroscope
			require('telescope').load_extension 'neoclip'
			require('telescope').load_extension 'macroscope'
			map('n', '<leader>fc', require('telescope').extensions.neoclip.default, opts 'Neoclip')
			map('n', '<leader>fm', require('telescope').extensions.macroscope.default, opts 'Macroscope')

			-- Scriptnames
			require('telescope').load_extension 'scriptnames'

			-- yanky
			require('telescope').load_extension 'yank_history'

			-- dir-telescope
			require('telescope').load_extension 'dir'

            -- undo
			require('telescope').load_extension 'undo'

            -- docker
			require('telescope').load_extension 'docker'

            -- cmdline 
			require('telescope').load_extension 'cmdline'

            -- helpgrep
			require('telescope').load_extension 'helpgrep' 

            -- lazy
			require('telescope').load_extension 'lazy' 

            -- lazy-pugins config
			require('telescope').load_extension 'lazy_plugins' 
            map('n', '<leader>fl', '<cmd>Telescope lazy_plugins<cr>', opts('Lazy Plugins Files'))

            -- resession 
			require('telescope').load_extension 'resession' 

            -- scope 
            require('telescope').load_extension 'scope'

            -- tasks
            local default = require('telescope').extensions.tasks.generators.default
            default.all()
			require('telescope').load_extension 'tasks'

            -- picker-list -  INFO: needs to be last
            require('telescope').load_extension 'picker_list'

			-- map('n', '<leader>ff', builtin.find_files, opts('Find files'))
			map('n', '<leader>ff', '<cmd>Telescope pathogen find_files<cr>', opts 'Find files')
			map('n', '<leader>fg', '<cmd>Telescope pathogen live_grep<cr>', opts 'Live Grep')
			map('n', '<leader>qb', '<cmd>Telescope pathogen quick_buffer<cr>', opts 'Quick Buffers/Old Files')
			map('n', '<leader>bf', '<cmd>Telescope pathogen<cr>', opts 'Browse Files')
			map('n', '<leader>fb', builtin.buffers, opts 'Show Buffers')
			map('n', '<leader>fh', builtin.help_tags, opts 'Help Tags')
			map('n', '<leader><leader>', builtin.oldfiles, opts 'Old Files')
			-- TODO: LSP Mappings
		end,
	},
}
