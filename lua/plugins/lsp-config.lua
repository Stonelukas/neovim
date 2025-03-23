---@diagnostic disable: unused-local, missing-fields
return {
    {
        "maan2003/lsp_lines.nvim",
        lazy = false,
        enabled = false,
        config = function()
            require("lsp_lines").setup()
            vim.keymap.set("", "<Leader>tl", require("lsp_lines").toggle, { desc = "Toggle lsp_lines" })
        end,
    },
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
        "neovim/nvim-lspconfig",
        lazy = true,
        opts = {
            servers = {
                lua_ls = {
                    settings = {
                        Lua = {
                            runtime = {
                                version = "LuaJIT",
                                special = { reload = "require" },
                            },
                            diagnostics = {
                                globals = { "vim" },
                            },
                            completion = {
                                callSnippet = "Replace",
                                displayContext = 10,
                                keywordSnippet = "Replace",
                            },
                            hint = {
                                arrayIndex = "Enable",
                                enabled = true,
                                setType = true,
                            }
                        },
                    },
                },
                pyright = {},
                ts_ls = {},
                html = {},
                cssls = {},
                tailwindcss = {},
                jsonls = {},
                rust_analyzer = {},
            },
        },
        config = function(_, opts)
            local lspconfig = require("lspconfig")
            local util = require("lspconfig.util")
            local capabilities = require("blink.cmp").get_lsp_capabilities()

            for server, config in pairs(opts.servers) do
                config.capabilities = require("blink.cmp").get_lsp_capabilities(config.capabilities)
                lspconfig[server].setup(config)
            end

            lspconfig.marksman.setup({
                capabilities = capabilities,
                filetypes = { "markdown", "quarto", "Avante" },
                root_dir = util.root_pattern(".git", ".marksman.toml", "_quarto.yml"),
            })

            vim.api.nvim_create_autocmd("LspNotify", {
                callback = function(args)
                    local bufnr = args.buf
                    local client_id = args.data.client_id
                    local method = args.data.method
                    local params = args.data.params

                    -- do something with the notification
                    if method == "textDocument/..." then
                        ---@diagnostic disable-next-line: redefined-local
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

            signs({ name = "DiagnosticSignError", text = "" })
            signs({ name = "DiagnosticSignWarn", text = "" })
            signs({ name = "DiagnosticSignHint", text = "" })
            signs({ name = "DiagnosticSignInfo", text = "" })

            local opts = { buffer = bufnr, noremap = true, silent = true }
            vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
            vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
            vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
            vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
            vim.keymap.set("i", "<C-i>", function()
                vim.lsp.completion.trigger()
            end, opts)
            vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)
            vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
            vim.keymap.set("n", "<leader>wl", function()
                print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
            end, opts)
            vim.keymap.set("n", "<leader>dc", vim.lsp.buf.workspace_symbol, opts)
            vim.keymap.set("n", "<leader>p", function()
                vim.diagnostic.jump({ count = -1 })
            end, opts)
            vim.keymap.set("n", "<leader>n", function()
                vim.diagnostic.jump({ count = 1 })
            end, opts)
            vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, opts)
        end,
    },
    {
        "mihyaeru21/nvim-ruby-lsp",
        dependencies = { "neovim/nvim-lspconfig" },
        config = function()
            require("ruby-lsp").setup()
            local capabilities = require("blink.cmp").get_lsp_capabilities()

            local lspconfig = require("lspconfig")
            lspconfig.ruby_lsp.setup({
                capabilities = capabilities,
            })
        end,
    },
    {
        "ray-x/lsp_signature.nvim",
        cond = false,
        config = function()
            require("lsp_signature").setup({
                bind = true,
                handler_opts = {
                    border = "rounded",
                },
                wrap = true,
                hint_prefix = {
                    above = "↙ ", -- when the hint is on the line above the current line
                    current = "← ", -- when the hint is on the same line
                    below = "↖ ", -- when the hint is on the line below the current line
                },
                floating_window_off_x = 5, -- adjust float windows x position.
                floating_window_off_y = function() -- adjust float windows y position. e.g. set to -2 can make floating window move up 2 lines
                    local linenr = vim.api.nvim_win_get_cursor(0)[1] -- buf line number
                    local pumheight = vim.o.pumheight
                    local winline = vim.fn.winline() -- line number in the window
                    local winheight = vim.fn.winheight(0)

                    -- window top
                    if winline - 1 < pumheight then
                        return pumheight
                    end

                    -- window bottom
                    if winheight - winline < pumheight then
                        return -pumheight
                    end
                    return 0
                end,
            })

            vim.keymap.set({ "n" }, "<leader>lk", function()
                require("lsp_signature").toggle_float_win()
            end, { silent = true, noremap = true, desc = "toggle signature" })
        end,
    },
    {
        "linrongbin16/lsp-progress.nvim",
        config = function()
            require("lsp-progress").setup({
                client_format = function(client_name, spinner, series_messages)
                    if #series_messages == 0 then
                        return nil
                    end
                    return {
                        name = client_name,
                        body = spinner .. " " .. table.concat(series_messages, ", "),
                    }
                end,
                format = function(client_messages)
                    local function stringify(name, msg)
                        return msg and string.format("%s %s", name, msg) or name
                    end

                    local sign = "" -- nf-fa-gear \uf013end
                    local lsp_clients = vim.lsp.get_clients()
                    local messages_map = {}
                    for _, climsg in ipairs(client_messages) do
                        messages_map[climsg.name] = climsg.body
                    end

                    if #lsp_clients > 0 then
                        table.sort(lsp_clients, function(a, b)
                            return a.name < b.name
                        end)
                        local builder = {}
                        for _, cli in ipairs(lsp_clients) do
                            if type(cli) == "table" and type(cli.name) == "string" and string.len(cli.name) > 0 then
                                if messages_map[cli.name] then
                                    table.insert(builder, stringify(cli.name, messages_map[cli.name]))
                                else
                                    table.insert(builder, stringify(cli.name))
                                end
                            end
                        end
                        if #builder > 0 then
                            return sign .. " " .. table.concat(builder, ", ")
                        end
                    end
                    return ""
                end,
            })
        end,
    },
    {
        "dnlhc/glance.nvim",
        config = function()
            require("glance").setup({
                height = 30,
                border = {
                    enable = true,
                },
                hooks = {
                    before_open = function(results, open, jump, method)
                        local uri = vim.uri_from_bufnr(0)
                        if #results == 1 then
                            local target_uri = results[1].uri or results[1].targetUri

                            if target_uri == uri then
                                jump(results[1])
                            else
                                open(results)
                            end
                        else
                            open(results)
                        end
                    end,
                },
                use_trouble_qf = true,
            })
            vim.keymap.set("n", "gD", "<CMD>Glance definitions<CR>")
            vim.keymap.set("n", "grr", "<CMD>Glance references<CR>")
            vim.keymap.set("n", "gY", "<CMD>Glance type_definitions<CR>")
            vim.keymap.set("n", "gri", "<CMD>Glance implementations<CR>")
        end,
    },
    {
        "nvim-lua/popup.nvim",
    },
}
