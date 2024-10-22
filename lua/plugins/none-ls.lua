return {
    {
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

            local async_formatting = function(bufnr)
                bufnr = bufnr or vim.api.nvim_get_current_buf()

                vim.lsp.buf_request(
                    bufnr,
                    "textDocument/formatting",
                    vim.lsp.util.make_formatting_params({}),
                    function(err, res, ctx)
                        if err then
                            local err_msg = type(err) == "string" and err or err.message
                            -- you can modify the log message / level (or ignore it completely)
                            vim.notify("formatting: " .. err_msg, vim.log.levels.WARN)
                            return
                        end

                        -- don't apply results if buffer is unloaded or has been modified
                        if not vim.api.nvim_buf_is_loaded(bufnr) or vim.api.nvim_buf_get_option(bufnr, "modified") then
                            return
                        end

                        if res then
                            local client = vim.lsp.get_client_by_id(ctx.client_id)
                            vim.lsp.util.apply_text_edits(res, bufnr, client and client.offset_encoding or "utf-16")
                            vim.api.nvim_buf_call(bufnr, function()
                                vim.cmd("silent noautocmd update")
                            end)
                        end
                    end
                )
            end

            null_ls.setup({
                sources = {
                    null_ls.builtins.formatting.stylua,
                    null_ls.builtins.formatting.prettierd,
                    --[[ null_ls.builtins.formatting.pylint, ]]
                    null_ls.builtins.formatting.black,
                    null_ls.builtins.formatting.isort,
                    null_ls.builtins.formatting.gofmt,
                    null_ls.builtins.completion.spell,
                    null_ls.builtins.completion.luasnip,
                    null_ls.builtins.completion.vsnip,
                    null_ls.builtins.completion.tags,
                    null_ls.builtins.diagnostics.zsh,
                    null_ls.builtins.diagnostics.commitlint,
                    null_ls.builtins.diagnostics.gitlint,
                    -- null_ls.builtins.diagnostics.selene,
                    null_ls.builtins.code_actions.gitrebase,
                    null_ls.builtins.code_actions.gitsigns,
                    null_ls.builtins.code_actions.refactoring,
                    --[[ require("none-ls.diagnostics.eslint"), ]]
                    require("none-ls.diagnostics.cpplint"),
                    require("none-ls.formatting.jq"),
                    require("none-ls.code_actions.eslint"),
                },

                on_attach = function(client, bufnr)
                    if client.supports_method("textDocument/formatting") then
                        vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
                        vim.api.nvim_create_autocmd("BufWritePre", {
                            group = augroup,
                            buffer = bufnr,
                            callback = function()
                                -- async_formatting(bufnr)
                                -- lsp_formatting(bufnr)
                            end,
                        })
                    end
                end,

                debug = true,
            })

            vim.keymap.set("n", "<leader>F", vim.lsp.buf.format, {})
        end,
    },
    {
        "zeioth/none-ls-autoload.nvim",
        event = "BufEnter",
        dependencies = {
            "williamboman/mason.nvim",
            "zeioth/none-ls-external-sources.nvim",
        },
        opts = {
            -- Here you can add support for sources not oficially suppored by none-ls.
            external_sources = {
                -- diagnostics
                "none-ls-external-sources.diagnostics.cpplint",
                "none-ls-external-sources.diagnostics.eslint",
                "none-ls-external-sources.diagnostics.eslint_d",
                "none-ls-external-sources.diagnostics.flake8",
                "none-ls-external-sources.diagnostics.psalm",
                -- "none-ls-external-sources.diagnostics.shellcheck",
                "none-ls-external-sources.diagnostics.yamllint",

                -- formatting
                "none-ls-external-sources.formatting.autopep8",
                "none-ls-external-sources.formatting.beautysh",
                "none-ls-external-sources.formatting.easy-coding-standard",
                "none-ls-external-sources.formatting.eslint",
                "none-ls-external-sources.formatting.eslint_d",
                "none-ls-external-sources.formatting.jq",
                "none-ls-external-sources.formatting.latexindent",
                "none-ls-external-sources.formatting.reformat_gherkin",
                "none-ls-external-sources.formatting.rustfmt",
                "none-ls-external-sources.formatting.standardrb",
                "none-ls-external-sources.formatting.yq",

                -- code actions
                "none-ls-external-sources.code_actions.eslint",
                "none-ls-external-sources.code_actions.eslint_d",
                -- "none-ls-external-sources.code_actions.shellcheck",
            },
        },
    },
}
