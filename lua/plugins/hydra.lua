return {
	{
		"nvimtools/hydra.nvim",
		config = function()
			local Hydra = require("hydra")
			local gitsigns = require("gitsigns")
			require("hydra").setup({
				debug = false,
				exit = false,
				foreign_keys = nil,
				color = "red",
				timeout = false,
				invoke_on_body = false,
				hint = {
					show_name = true,
					position = { "bottom" },
					offset = 0,
					float_opts = {
						border = "rounded",
						title_pos = "center",
					},
				},
				on_enter = nil,
				on_exit = nil,
				on_key = nil,
			})

			Hydra({
				name = "Side scroll",
				mode = "n",
				body = "g<C-w>",
				heads = {
					{ "h", "5zh" },
					{ "l", "5zl", { desc = "←/→" } },
					{ "H", "zH" },
					{ "L", "zL", { desc = "half screen ←/→" } },
					{ "q", nil, { exit = true, nowait = true } },
				},
			})

			local git_hint = [[
_J_: next hunk   _s_: stage hunk        _d_: show deleted   _b_: blame line
 _K_: prev hunk   _u_: undo last stage   _p_: preview hunk   _B_: blame show full
 ^ ^              _S_: stage buffer      ^ ^                 _/_: show base file
 ^
 ^ ^              _<Enter>_: Neogit              _q_: exit
]]
			Hydra({
				name = "Git",
				hint = git_hint,
				config = {
					color = "pink",
					invoke_on_body = true,
					hint = {
						position = "bottom",
						float_opts = {
							border = "rounded",
							title = "Git",
							title_pos = "center",
						},
					},
					on_enter = function()
						vim.bo.modifiable = false
						gitsigns.toggle_signs(true)
						gitsigns.toggle_linehl(true)
					end,
					on_exit = function()
						gitsigns.toggle_signs(false)
						gitsigns.toggle_linehl(false)
						gitsigns.toggle_deleted(false)
						vim.cmd("echo") -- clear the echo area
					end,
				},
				mode = { "n", "x" },
				body = "<leader>g",
				heads = {
					{
						"J",
						function()
							if vim.wo.diff then
								return "]c"
							end
							vim.schedule(function()
								gitsigns.next_hunk()
							end)
							return "<Ignore>"
						end,
						{ expr = true },
					},
					{
						"K",
						function()
							if vim.wo.diff then
								return "[c"
							end
							vim.schedule(function()
								gitsigns.prev_hunk()
							end)
							return "<Ignore>"
						end,
						{ expr = true },
					},
					{ "s", ":Gitsigns stage_hunk<CR>", { silent = true } },
					{ "u", gitsigns.undo_stage_hunk },
					{ "S", gitsigns.stage_buffer },
					{ "p", gitsigns.preview_hunk },
					{ "d", gitsigns.toggle_deleted, { nowait = true } },
					{ "b", gitsigns.blame_line },
					{
						"B",
						function()
							gitsigns.blame_line({ full = true })
						end,
					},
					{ "/", gitsigns.show, { exit = true } }, -- show the base of the file
					{ "<Enter>", "<cmd>Neogit<CR>", { exit = true } },
					{ "q", nil, { exit = true, nowait = true } },
				},
			})

			local cmd = require("hydra.keymap-util").cmd

			local telescope_hint = [[
                 _f_: files       _j_: Jumplist
   🭇🬭🬭🬭🬭🬭🬭🬭🬭🬼    _o_: old files   _g_: live grep
  🭉🭁🭠🭘    🭣🭕🭌🬾   _p_: projects    _/_: search in file
  🭅█ ▁     █🭐
  ██🬿      🭊██   _r_: resume      _u_: undotree
 🭋█🬝🮄🮄🮄🮄🮄🮄🮄🮄🬆█🭀  _h_: vim help    _c_: execute command
 🭤🭒🬺🬹🬱🬭🬭🬭🬭🬵🬹🬹🭝🭙  _k_: keymaps     _;_: commands history
                 _O_: options     _?_: search history
 ^
                 _<Enter>_: Telescope           _q_:exit
]]

			Hydra({
				name = "Telescope",
				hint = telescope_hint,
				config = {
					color = "teal",
					invoke_on_body = true,
					hint = {
						position = "middle",
						float_opts = {
							border = "rounded",
							title = "Telescope",
							title_pos = "center",
						},
					},
				},
				mode = "n",
				body = "<Leader>t",
				heads = {
					{ "f", cmd("Telescope find_files") },
					{ "g", cmd("Telescope live_grep") },
					{ "o", cmd("Telescope oldfiles"), { desc = "recently opened files" } },
					{ "h", cmd("Telescope help_tags"), { desc = "vim help" } },
					-- { "m", cmd("MarksListBuf"), { desc = "marks" } },
					{ "j", cmd("Telescope jumplist"), { desc = "Jumplist" } },
					{ "k", cmd("Telescope keymaps") },
					{ "O", cmd("Telescope vim_options") },
					{ "r", cmd("Telescope resume") },
					{ "p", cmd("Telescope project"), { desc = "projects" } },
					{ "/", cmd("Telescope current_buffer_fuzzy_find"), { desc = "search in file" } },
					{ "?", cmd("Telescope search_history"), { desc = "search history" } },
					{ ";", cmd("Telescope command_history"), { desc = "command-line history" } },
					{ "c", cmd("Telescope commands"), { desc = "execute command" } },
					{ "u", cmd("silent! %foldopen! | UndotreeToggle"), { desc = "undotree" } },
					{
						"<Enter>",
						cmd("Telescope"),
						{ exit = true, desc = "list all pickers" },
					},
					{ "q", nil, { exit = true, nowait = true } },
				},
			})

			local selmove_hint = [[
             Arrow^^^^^^
             ^ ^ _k_ ^ ^
             _h_ ^ ^ _l_
             ^ ^ _j_ ^ ^                  _q_:exit
            ]]

			local ok_minimove, minimove = pcall(require, "mini.move")
			assert(ok_minimove)
			if ok_minimove == true then
				local opts = {
					mappings = {
						left = "",
						right = "",
						down = "",
						up = "",
						line_left = "",
						line_right = "",
						line_down = "",
						line_up = "",
					},
				}

				minimove.setup(opts)
				-- setup here prevents needless global vars for opts required by `move_selection()/moveline()`
				Hydra({
					name = "Move Box Selection",
					hint = selmove_hint,
					config = {
						color = "pink",
						invoke_on_body = true,
						hint = {
							float_opts = {
								border = "rounded",
								title = "Move Box Selection",
								title_pos = "center",
							},
						},
					},
					mode = "v",
					body = "<leader>vb",
					heads = {
						{
							"h",
							function()
								minimove.move_selection("left", opts)
							end,
						},
						{
							"j",
							function()
								minimove.move_selection("down", opts)
							end,
						},
						{
							"k",
							function()
								minimove.move_selection("up", opts)
							end,
						},
						{
							"l",
							function()
								minimove.move_selection("right", opts)
							end,
						},
						{ "q", nil, { exit = true, nowait = true } },
					},
				})
				Hydra({
					name = "Move Line Selection",
					hint = selmove_hint,
					config = {
						color = "pink",
						invoke_on_body = true,
						hint = {
							float_opts = {
								border = "rounded",
								title = "Move Line Selection",
								title_pos = "center",
							},
						},
					},
					mode = "n",
					body = "<leader>vl",
					heads = {
						{
							"h",
							function()
								minimove.move_line("left", opts)
							end,
						},
						{
							"j",
							function()
								minimove.move_line("down", opts)
							end,
						},
						{
							"k",
							function()
								minimove.move_line("up", opts)
							end,
						},
						{
							"l",
							function()
								minimove.move_line("right", opts)
							end,
						},
						{ "q", nil, { exit = true, nowait = true } },
					},
				})
			end

			Hydra({
				name = "Quick words",
				hint = "statusline",
				config = {
					color = "pink",
					hint = {
						float_opts = {
							border = "rounded",
							title = "Quick words",
							title_pos = "center",
						},
					},
				},
				mode = { "n", "x", "o" },
				body = ",",
				heads = {
					{ "w", "<Plug>(smartword-w)" },
					{ "b", "<Plug>(smartword-b)" },
					{ "e", "<Plug>(smartword-e)" },
					{ "ge", "<Plug>(smartword-ge)" },
					{ "q", nil, { exit = true, mode = "n", nowait = true } },
				},
			})

			local vim_options_hint = [[
  ^ ^        Options
  ^
  _v_ %{ve} virtual edit
  _i_ %{list} invisible characters
  _s_ %{spell} spell
  _w_ %{wrap} wrap
  _c_ %{cul} cursor line
  _n_ %{nu} number
  _r_ %{rnu} relative number
  ^
       ^^^^                _<Esc>_
]]

			Hydra({
				name = "Options",
				hint = vim_options_hint,
				config = {
					color = "amaranth",
					invoke_on_body = true,
					hint = {
						position = "middle",
						float_opts = {
							border = "rounded",
							title = "Vim Options",
							title_pos = "center",
						},
					},
				},
				mode = { "n", "x" },
				body = "<leader>o",
				heads = {
					{
						"n",
						function()
							if vim.o.number == true then
								vim.o.number = false
							else
								vim.o.number = true
							end
						end,
						{ desc = "number" },
					},
					{
						"r",
						function()
							if vim.o.relativenumber == true then
								vim.o.relativenumber = false
							else
								vim.o.number = true
								vim.o.relativenumber = true
							end
						end,
						{ desc = "relativenumber" },
					},
					{
						"v",
						function()
							if vim.opt.virtualedit == "all" then
								vim.opt.virtualedit = "block"
							else
								vim.opt.virtualedit = "all"
							end
						end,
						{ desc = "virtualedit" },
					},
					{
						"i",
						function()
							if vim.o.list == true then
								vim.o.list = false
							else
								vim.o.list = true
							end
						end,
						{ desc = "show invisible" },
					},
					{
						"s",
						function()
							if vim.o.spell == true then
								vim.o.spell = false
							else
								vim.o.spell = true
							end
						end,
						{ exit = true, desc = "spell" },
					},
					{
						"w",
						function()
							if vim.o.wrap == true then
								vim.o.wrap = true
								-- Dealing with word wrap:
								-- If cursor is inside very long line in the file than wraps
								--
								-- around several rows on the screen, then 'j' key moves you to
								-- the next line in the file, but not to the next row on the
								-- screen under your previous position as in other editors. These
								-- bindings fixes this.
								vim.keymap.set("n", "k", function()
									return vim.v.count > 0 and "k" or "gk"
								end, { expr = true, desc = "k or gk" })
								vim.keymap.set("n", "j", function()
									return vim.v.count > 0 and "j" or "gj"
								end, { expr = true, desc = "j or gj" })
							else
								vim.o.wrap = false
								vim.keymap.del("n", "k")
								vim.keymap.del("n", "j")
							end
						end,
						{ desc = "wrap" },
					},
					{
						"c",
						function()
							if vim.o.cursorline == true then
								vim.o.cursorline = false
							else
								vim.o.cursorline = true
							end
						end,
						{ desc = "cursor line" },
					},
					{ "<Esc>", nil, { exit = true } },
				},
			})

			local splits = require("smart-splits")

			local cmd = require("hydra.keymap-util").cmd
			local pcmd = require("hydra.keymap-util").pcmd

			local buffer_hydra = Hydra({
				name = "Barbar",
				config = {
					on_key = function()
						-- Preserve animation
						vim.wait(200, function()
							vim.cmd("redraw")
						end, 30, false)
					end,
					hint = {
						float_opts = {
							border = "rounded",
							title = "Vim Options",
							title_pos = "center",
						},
					},
				},
				body = "<leader>bb",
				heads = {
					{
						"h",
						function()
							vim.cmd("BufferPrevious")
						end,
						{ on_key = false },
					},
					{
						"l",
						function()
							vim.cmd("BufferNext")
						end,
						{ desc = "choose", on_key = false },
					},

					{
						"H",
						function()
							vim.cmd("BufferMovePrevious")
						end,
					},
					{
						"L",
						function()
							vim.cmd("BufferMoveNext")
						end,
						{ desc = "move" },
					},

					{
						"p",
						function()
							vim.cmd("BufferPin")
						end,
						{ desc = "pin" },
					},

					{
						"d",
						function()
							vim.cmd("BufferClose")
						end,
						{ desc = "close" },
					},
					{
						"c",
						function()
							vim.cmd("BufferClose")
						end,
						{ desc = false },
					},
					{
						"q",
						function()
							vim.cmd("BufferClose")
						end,
						{ desc = false },
					},

					{
						"od",
						function()
							vim.cmd("BufferOrderByDirectory")
						end,
						{ desc = "by directory" },
					},
					{
						"ol",
						function()
							vim.cmd("BufferOrderByLanguage")
						end,
						{ desc = "by language" },
					},
					{ "<Esc>", nil, { exit = true } },
				},
			})

			local function choose_buffer()
				if #vim.fn.getbufinfo({ buflisted = true }) > 1 then
					buffer_hydra:activate()
				end
			end

			vim.keymap.set("n", "<leader>gb", choose_buffer)

			local window_hint = [[
 ^^^^^^^^^^^^     Move      ^^    Size   ^^   ^^     Split
 ^^^^^^^^^^^^-------------  ^^-----------^^   ^^---------------
 ^ ^ _k_ ^ ^  ^ ^ _K_ ^ ^   ^   _<C-k>_   ^   _s_: horizontally
 _h_ ^ ^ _l_  _H_ ^ ^ _L_   _<C-h>_ _<C-l>_   _v_: vertically
 ^ ^ _j_ ^ ^  ^ ^ _J_ ^ ^   ^   _<C-j>_   ^   _q_, _c_: close
 focus^^^^^^  window^^^^^^  ^_=_: equalize^   _z_: maximize
 ^ ^ ^ ^ ^ ^  ^ ^ ^ ^ ^ ^   ^^ ^          ^   _o_: remain only
 _b_: choose buffer
]]

			Hydra({
				name = "Windows",
				hint = window_hint,
				config = {
					invoke_on_body = true,
					hint = {
						offset = -1,
						float_opts = {
							border = "rounded",
							title = "Vim Options",
							title_pos = "center",
						},
					},
				},
				mode = "n",
				body = "<C-w>",
				heads = {
					{ "h", "<C-w>h" },
					{ "j", "<C-w>j" },
					{ "k", pcmd("wincmd k", "E11", "close") },
					{ "l", "<C-w>l" },

					{ "H", cmd("WinShift left") },
					{ "J", cmd("WinShift down") },
					{ "K", cmd("WinShift up") },
					{ "L", cmd("WinShift right") },

					{
						"<C-h>",
						function()
							splits.resize_left(2)
						end,
					},
					{
						"<C-j>",
						function()
							splits.resize_down(2)
						end,
					},
					{
						"<C-k>",
						function()
							splits.resize_up(2)
						end,
					},
					{
						"<C-l>",
						function()
							splits.resize_right(2)
						end,
					},
					{ "=", "<C-w>=", { desc = "equalize" } },

					{ "s", pcmd("split", "E36") },
					{ "<C-s>", pcmd("split", "E36"), { desc = false } },
					{ "v", pcmd("vsplit", "E36") },
					{ "<C-v>", pcmd("vsplit", "E36"), { desc = false } },

					{ "w", "<C-w>w", { exit = true, desc = false } },
					{ "<C-w>", "<C-w>w", { exit = true, desc = false } },

					{ "z", cmd("WindowsMaximaze"), { exit = true, desc = "maximize" } },
					{ "<C-z>", cmd("WindowsMaximaze"), { exit = true, desc = false } },

					{ "o", "<C-w>o", { exit = true, desc = "remain only" } },
					{ "<C-o>", "<C-w>o", { exit = true, desc = false } },

					{ "b", choose_buffer, { exit = true, desc = "choose buffer" } },

					{ "c", pcmd("close", "E444") },
					{ "q", pcmd("close", "E444"), { desc = "close window" } },
					{ "<C-c>", pcmd("close", "E444"), { desc = false } },
					{ "<C-q>", pcmd("close", "E444"), { desc = false } },

					{ "<Esc>", nil, { exit = true, desc = false } },
				},
			})
		end,
	},
}
