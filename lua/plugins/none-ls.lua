---@diagnostic disable: undefined-global
return {
	"nvimtools/none-ls.nvim",
	dependencies = {
		"nvimtools/none-ls-extras.nvim",
		"nvim-lua/plenary.nvim",
	},
	config = function()
		local null_ls = require("null-ls")

		local lsp_formatting = function(bufnr)
			vim.lsp.buf.format({
				filter = function(client)
					-- apply whatever logic you want (in this example, we'll only use null-ls)
					return client.name == "null-ls"
				end,
				bufnr = bufnr,
			})
		end

		-- if you want to set up formatting on save, you can use this as a callback
		local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

		null_ls.setup({
			sources = {
				null_ls.builtins.formatting.stylua,
				null_ls.builtins.formatting.prettier,
				null_ls.builtins.formatting.black,
				null_ls.builtins.formatting.isort,
				null_ls.builtins.formatting.gofmt,
				null_ls.builtins.diagnostics.eslint,
				null_ls.builtins.completion.spell,
				null_ls.builtins.completion.luasnip,
				null_ls.builtins.formatting.prettier,
				require("none-ls.diagnostics.cpplint"),
				require("none-ls.formatting.jq"),
				require("none-ls.code_actions.eslint"),
			},

			on_attach = function(client, bufnr)
				if client.supports_method("textDocument/formatting") then
					vim.api.nvim_buf_create_user_command(bufnr, "LspFormatting", function()
						vim.lsp.buf.format({ bufnr = bufnr })
					end, {})
					vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
					vim.api.nvim_create_autocmd("BufWritePre", {
						group = augroup,
						buffer = bufnr,
						command = "undojoin | LspFormatting",
					})
				end
			end,

			debug = true,
		})

		vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, {})
	end,
}
