---@diagnostic disable: missing-fields
return {
	{
		"lewis6991/satellite.nvim",
		config = function()
			require("satellite").setup({
				current_only = true,
				winblend = 50,
				zindex = 40,
				excluded_filetypes = { "prompt", "TelescopePrompt", "noice", "notify", "neo-tree", "NvimTree" },
				width = 2,
				handlers = {
					baseconfig = {
						overlap = true,
						enable = true,
						priority = 1000,
					},
					cursor = {
						enable = true,
						-- Supports any number of symbols
						symbols = { "⎺", "⎻", "⎼", "⎽" },
						-- symbols = { '⎻', '⎼' }
						-- Highlights:
						-- - SatelliteCursor (default links to NonText
					},
					search = {
						enable = true,
						-- Highlights:
						-- - SatelliteSearch (default links to Search)
						-- - SatelliteSearchCurrent (default links to SearchCurrent)
					},
					diagnostic = {
						enable = true,
						signs = { "", "", "", "" },
						min_severity = vim.diagnostic.severity.INFO,
						-- Highlights:
						-- - SatelliteDiagnosticError (default links to DiagnosticError)
						-- - SatelliteDiagnosticWarn (default links to DiagnosticWarn)
						-- - SatelliteDiagnosticInfo (default links to DiagnosticInfo)
						-- - SatelliteDiagnosticHint (default links to DiagnosticHint)
					},
					gitsigns = {
						enable = true,
						signs = { -- can only be a single character (multibyte is okay)
							add = "│",
							change = "│",
							delete = "-",
						},
						-- Highlights:
						-- SatelliteGitSignsAdd (default links to GitSignsAdd)
						-- SatelliteGitSignsChange (default links to GitSignsChange)
						-- SatelliteGitSignsDelete (default links to GitSignsDelete)
					},
					marks = {
						enable = true,
						show_builtins = false, -- shows the builtin marks like [ ] < >
						key = "m",
						-- Highlights:
						-- SatelliteMark (default links to Normal)
					},
					quickfix = {
						---@diagnostic disable-next-line: missing-fields
						signs = { "-", "=", "≡" },
						-- Highlights:
						-- SatelliteQuickfix (default links to WarningMsg)
					},
				},
			})
		end,
	},
	{
		"kevinhwang91/nvim-hlslens",
		config = function()
			require("hlslens").setup({
				calm_down = true,
				build_position_cb = function(plist, _, _, _)
					require("scrollbar.handlers.search").handler.show(plist.start_pos)
				end,
				override_lens = function(render, posList, nearest, idx, relIdx)
					local sfw = vim.v.searchforward == 1
					local indicator, text, chunks
					local absRelIdx = math.abs(relIdx)
					if absRelIdx > 1 then
						indicator = ("%d%s"):format(absRelIdx, sfw ~= (relIdx > 1) and "▲" or "▼")
					elseif absRelIdx == 1 then
						indicator = sfw ~= (relIdx == 1) and "▲" or "▼"
					else
						indicator = ""
					end

					local lnum, col = unpack(posList[idx])
					if nearest then
						local cnt = #posList
						if indicator ~= "" then
							text = ("[%s %d/%d]"):format(indicator, idx, cnt)
						else
							text = ("[%d/%d]"):format(idx, cnt)
						end
						chunks = { { " " }, { text, "HlSearchLensNear" } }
					else
						text = ("[%s %d]"):format(indicator, idx)
						chunks = { { " " }, { text, "HlSearchLens" } }
					end
					render.setVirt(0, lnum - 1, col - 1, chunks, nearest)
				end,
			})

			local kopts = { noremap = true, silent = true }

			vim.api.nvim_set_keymap(
				"n",
				"n",
				[[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]],
				kopts
			)
			vim.api.nvim_set_keymap(
				"n",
				"N",
				[[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]],
				kopts
			)
			vim.api.nvim_set_keymap("n", "*", [[*<Cmd>lua require('hlslens').start()<CR>]], kopts)
			vim.api.nvim_set_keymap("n", "#", [[#<Cmd>lua require('hlslens').start()<CR>]], kopts)
			vim.api.nvim_set_keymap("n", "g*", [[g*<Cmd>lua require('hlslens').start()<CR>]], kopts)
			vim.api.nvim_set_keymap("n", "g#", [[g#<Cmd>lua require('hlslens').start()<CR>]], kopts)

			vim.keymap.set({ "n", "x" }, "<Leader>L", function()
				vim.schedule(function()
					if require("hlslens").exportLastSearchToQuickfix() then
						vim.cmd("cw")
					end
				end)
				return ":noh<CR>"
			end, { expr = true })

			vim.api.nvim_set_keymap("n", "<Leader>l", "<Cmd>noh<CR>", kopts)
		end,
	},
}
