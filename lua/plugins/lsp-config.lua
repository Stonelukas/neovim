return {
	-- {
	-- 	"folke/neodev.nvim",
	-- 	config = function()
	-- 		require("neodev").setup({
	-- 			library = { plugins = { "nvim-dap-ui" }, types = true },
	-- 		})
	-- 		local lspconfig = require("lspconfig")
	--
	-- 		-- example to setup lua_ls and enable call snippets
	-- 		lspconfig.lua_ls.setup({
	-- 			settings = {
	-- 				Lua = {
	-- 					completion = {
	-- 						callSnippet = "Replace",
	-- 					},
	-- 				},
	-- 			},
	-- 		})
	-- 	end,
	-- },
	{
		"williamboman/mason.nvim",
		lazy = false,
		config = function()
			require("mason").setup({
				ui = {
					icons = {
						package_installed = "",
						package_pending = "",
						package_uninstalled = "",
					},
				},
			})
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		lazy = false,
		opts = {
			auto_install = true,
		},
	},
	{
		"simrat39/rust-tools.nvim",
		config = function()
			local rt = require("rust-tools")

			rt.setup({
				server = {
					on_attach = function(_, bufnr)
						-- Hover actions
						vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
						-- Code action groups
						vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
					end,
				},
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		lazy = true,
		config = function()
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities.textDocument.completion.completionItem.snippetSupport = true
			local lspconfig = require("lspconfig")
			local servers = {
				"pyright",
				"tsserver",
				"biome",
				"solargraph",
				"html",
				"lua_ls",
				"jsonls",
				"prettier",
				"jsonlint",
			}

			vim.cmd([[autocmd! ColorScheme * highlight NormalFloat guibg=#1f2335]])
			vim.cmd([[autocmd! ColorScheme * highlight FloatBorder guifg=white guibg=#1f2335]])

			local border = {
				{ "🭽", "FloatBorder" },
				{ "▔", "FloatBorder" },
				{ "🭾", "FloatBorder" },
				{ "▕", "FloatBorder" },
				{ "🭿", "FloatBorder" },
				{ "▁", "FloatBorder" },
				{ "🭼", "FloatBorder" },
				{ "▏", "FloatBorder" },
			}

			-- LSP settings (for overriding per client)
			local handlers = {
				["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = border }),
				["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = border }),
			}

			-- To instead override globally
			local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
			function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
				opts = opts or {}
				opts.border = opts.border or border
				return orig_util_open_floating_preview(contents, syntax, opts, ...)
			end

			require("lspconfig.ui.windows").default_options.border = "single"

			require("lspconfig").lua_ls.setup({
				handlers = handlers,
				on_init = function(client)
					local path = client.workspace_folders[1].name
					if vim.loop.fs_stat(path .. "/.luarc.json") or vim.loop.fs_stat(path .. "/.luarc.jsonc") then
						return
					end

					client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
						runtime = {
							-- Tell the language server which version of Lua you're using
							-- (most likely LuaJIT in the case of Neovim)
							version = "LuaJIT",
						},
						-- Make the server aware of Neovim runtime files
						workspace = {
							checkThirdParty = true,
							library = {
								vim.env.VIMRUNTIME,
								-- Depending on the usage, you might want to add additional paths here.
								-- "${3rd}/luv/library"
								-- "${3rd}/busted/library",
							},
							-- or pull in all of 'runtimepath'. NOTE: this is a lot slower
							-- library = vim.api.nvim_get_runtime_file("", true)
						},
					})
				end,
				settings = {
					Lua = {
						addonManager = {
							enable = true,
						},
						codeLens = {
							enable = true,
						},
						completion = {
							callSnippet = true,
							displayContext = 10,
							keywordSnippet = "Both",
							showWord = "Enable",
						},
						diagnostics = {
							workspaceEvent = "OnChange",
						},
						doc = {},
						format = {
							enable = true,
							defaultConfig = {},
						},
						hint = {
							enable = true,
							setType = true,
						},
						hover = {},
						misc = {},
						nameStyle = {
							config = {},
						},
						runtime = {
							builtin = {
								basic = "enable",
								utf8 = "enable",
							},
						},
						semantic = {
							enable = true,
						},

						signatureHelp = {},
						spell = {},
						type = {},
						typeFormat = {
							config = {},
						},
						window = {},
						workspace = {
							checkThirdParty = true,
						},
					},
				},
			})

			for _, lsp in ipairs(servers) do
				lspconfig[lsp].setup({
					handlers = handlers,
					capabilities = capabilities,
				})
			end
			--[[ lspconfig.eslint.setup({
				capabilities = capabilities,

				on_attach = function(client, bufnr)
					vim.api.nvim_create_autocmd("BufWritePre", {
						buffer = bufnr,
						command = "EslintFixAll",
					})
				end,
			}) ]]
			lspconfig.rust_analyzer.setup({
				capabilities = capabilities,
				handlers = {
					["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
						-- Disable virtual_text
						virtual_text = true,
					}),
				},
			})

			vim.api.nvim_create_autocmd("LspNotify", {
				callback = function(args)
					local bufnr = args.buf
					local client_id = args.data.client_id
					local method = args.data.method
					local params = args.data.params

					-- do something with the notification
					if method == "textDocument/..." then
						function PrintDiagnostics(opts, bufnr, line_nr, client_id)
							bufnr = bufnr or 0
							line_nr = line_nr or (vim.api.nvim_win_get_cursor(0)[1] - 1)
							opts = opts or { ["lnum"] = line_nr }

							local line_diagnostics = vim.diagnostic.get(bufnr, opts)
							if vim.tbl_isempty(line_diagnostics) then
								return
							end

							local diagnostic_message = ""
							for i, diagnostic in ipairs(line_diagnostics) do
								diagnostic_message = diagnostic_message
									.. string.format("%d: %s", i, diagnostic.message or "")
								print(diagnostic_message)
								if i ~= #line_diagnostics then
									diagnostic_message = diagnostic_message .. "\n"
								end
							end
							vim.api.nvim_echo({ { diagnostic_message, "Normal" } }, false, {})
						end

						vim.api.nvim_create_autocmd("CursorHold", {
							group = vim.api.nvim_create_augroup("print_diagnostics", { clear = true }),
							callback = PrintDiagnostics,
						})
					end
				end,
			})

			-- LSP Diagnostics Options Setup
			local signs = function(opts)
				vim.fn.sign_define(opts.name, {
					texthl = opts.name,
					text = opts.text,
					numhl = "",
				})
			end

			signs({ name = "DiagnosticSignError", text = "" })
			signs({ name = "DiagnosticSignWarn", text = "" })
			signs({ name = "DiagnosticSignHint", text = "" })
			signs({ name = "DiagnosticSignInfo", text = "" })

			--[[ for type, icon in pairs(signs) do
				local hl = "DiagnosticSign" .. type
				vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
			end ]]

			-- You will likely want to reduce updatetime which affects CursorHold
			-- note: this setting is global and should be set only once
			vim.o.updatetime = 250
			vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
				group = vim.api.nvim_create_augroup("float_diagnostic", { clear = true }),
				callback = function()
					vim.diagnostic.open_float(nil, { focus = false })
				end,
			})

			on_attach = function(bufnr)
				vim.api.nvim_create_autocmd("CursorHold", {
					buffer = bufnr,
					callback = function()
						local opts = {
							focusable = false,
							close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
							border = "rounded",
							source = "always",
							prefix = " ",
							scope = "cursor",
						}
						vim.diagnostic.open_float(nil, opts)
					end,
				})
			end

			vim.diagnostic.config({
				virtual_text = {
					source = true,
				},
				signs = true,
				underline = true,
				update_in_insert = true,
				severity_sort = true,
				float = {
					border = "rounded",
					source = true,
					header = "",
					prefix = "",
				},
			})

			vim.cmd([[
            set signcolumn=yes
            autocmd CursorHold * lua vim.diagnostic.open_float(nil, { focusable = false })
            ]])

			local function goto_definition(split_cmd)
				local util = vim.lsp.util
				local log = require("vim.lsp.log")
				local api = vim.api

				-- note, this handler style is for neovim 0.5.1/0.6, if on 0.5, call with function(_, method, result)
				local handler = function(_, result, ctx)
					if result == nil or vim.tbl_isempty(result) then
						local _ = log.info() and log.info(ctx.method, "No location found")
						return nil
					end

					if split_cmd then
						vim.cmd(split_cmd)
					end

					if vim.islist(result) then
						util.jump_to_location(result[1])

						if #result > 1 then
							-- util.set_qflist(util.locations_to_items(result))
							vim.fn.setqflist(util.locations_to_items(result, ""))
							api.nvim_command("copen")
							api.nvim_command("wincmd p")
						end
					else
						util.jump_to_location(result)
					end
				end

				return handler
			end

			vim.lsp.handlers["textDocument/definition"] = goto_definition("split")

			local opts = { buffer = bufnr, noremap = true, silent = true }
			vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
			vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
			vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
			vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
			vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, opts)
			vim.keymap.set("n", "<leader>gi", vim.lsp.buf.implementation, opts)
			vim.keymap.set("n", "<leader>gr", require("telescope.builtin").lsp_references, opts)
			vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
			vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
			vim.keymap.set("i", "<C-i>", vim.lsp.buf.completion, opts)
			vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)
			vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
			vim.keymap.set("n", "<leader>wl", function()
				print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
			end, opts)
			vim.keymap.set("n", "<leader>dc", vim.lsp.buf.workspace_symbol, opts)
			vim.keymap.set("n", "<leader>p", vim.diagnostic.goto_prev, opts)
			vim.keymap.set("n", "<leader>n", vim.diagnostic.goto_next, opts)
			vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, opts)

			-- require("neodev").setup()
			require("mason-lspconfig").setup({
				ensure_installed = { "tsserver" },
			})
		end,
	},
}
