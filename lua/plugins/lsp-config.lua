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
            require("mason").setup()
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
        "neovim/nvim-lspconfig",
        lazy = true,
        config = function()
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

            require("lspconfig.ui.windows").default_options.border = "single"

            require("lspconfig").lua_ls.setup({})

            local lspconfig = require("lspconfig")
            local servers = { "tsserver", "biome", "solargraph", "html", "lua_ls" }
            for _, lsp in ipairs(servers) do
                lspconfig[lsp].setup({
                    capabilities = capabilities,
                })
            end
            lspconfig.eslint.setup({
                capabilities = capabilities,

                on_attach = function(client, bufnr)
                    vim.api.nvim_create_autocmd("BufWritePre", {
                        buffer = bufnr,
                        command = "EslintFixAll",
                    })
                end,
            })
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
                        update_buffer(bufnr)
                    end
                end,
            })

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
