---@diagnostic disable: unused-local, missing-fields
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
            capabilities.textDocument.completion.completionItem.resolveSupport = {
                properties = { "documentation", "detail", "additionalTextEdits" },
            }
            local lspconfig = require("lspconfig")
            local servers = {
                "beautysh",
                "pyright",
                "biome",
                "solargraph",
                "tailwindcss",
                "html",
                "lua_ls",
                "jsonls",
                "jsonlint",
            }

            ---- clangd ----
            local navic = require("nvim-navic")

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
                        ---@diagnostic disable-next-line: missing-fields
                        completion = {
                            autoRequire = true,
                            callSnippet = "Both",
                            displayContext = 10,
                            keywordSnippet = "Both",
                            showWord = "Enable",
                        },
                        ---@diagnostic disable-next-line: missing-fields
                        diagnostics = {

                            workspaceEvent = "OnChange",
                        },
                        ---@diagnostic disable-next-line: missing-fields
                        doc = {},
                        format = {
                            enable = true,
                            defaultConfig = {},
                        },
                        ---@diagnostic disable-next-line: missing-fields
                        hint = {
                            enable = true,
                            setType = true,
                        },
                        ---@diagnostic disable-next-line: missing-fields
                        hover = {},
                        ---@diagnostic disable-next-line: missing-fields
                        misc = {},
                        nameStyle = {
                            config = {},
                        },
                        ---@diagnostic disable-next-line: missing-fields
                        runtime = {
                            special = {
                                include = require,
                            },
                            ---@diagnostic disable-next-line: missing-fields
                            builtin = {
                                builtin = "enable",
                                io = "enable",
                                string = "enable",
                                basic = "enable",
                                utf8 = "enable",
                            },
                        },
                        ---@diagnostic disable-next-line: missing-fields
                        semantic = {
                            enable = true,
                        },

                        signatureHelp = {
                            enable = false,
                        },
                        ---@diagnostic disable-next-line: missing-fields
                        spell = {},
                        ---@diagnostic disable-next-line: missing-fields
                        type = {},
                        typeFormat = {
                            ---@diagnostic disable-next-line: missing-fields
                            config = {},
                        },
                        ---@diagnostic disable-next-line: missing-fields
                        window = {},
                        ---@diagnostic disable-next-line: missing-fields
                        workspace = {
                            checkThirdParty = true,
                        },
                    },
                },
            })

            for _, lsp in ipairs(servers) do
                lspconfig[lsp].setup({
                    on_attach = function(client, bufnr)
                        navic.attach(client, bufnr)
                    end,
                    handlers = handlers,
                    capabilities = capabilities,
                })
            end

            ---@diagnostic disable-next-line: missing-fields
            lspconfig.rust_analyzer.setup({
                capabilities = capabilities,
                handlers = {
                    ["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
                        -- Disable virtual_text
                        virtual_text = false,
                    }),
                },
            })

            ---@diagnostic disable-next-line: missing-fields
            require("lspconfig").clangd.setup({
                capabilities = capabilities,
                on_attach = function(client, bufnr)
                    navic.attach(client, bufnr)
                end,
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

            signs({ name = "DiagnosticSignError", text = "" })
            signs({ name = "DiagnosticSignWarn", text = "" })
            signs({ name = "DiagnosticSignHint", text = "" })
            signs({ name = "DiagnosticSignInfo", text = "" })

            --[[ for type, icon in pairs(signs) do
                local hl = "DiagnosticSign" .. type
                vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
            end ]]

            -- You will likely want to reduce updatetime which affects CursorHold
            -- note: this setting is global and should be set only once
            -- vim.o.updatetime = 250
            -- vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
            -- 	group = vim.api.nvim_create_augroup("float_diagnostic", { clear = true }),
            -- 	callback = function()
            -- 		vim.diagnostic.open_float(nil, { focus = false })
            -- 	end,
            -- })
            --
            -- on_attach = function(bufnr)
            -- 	vim.api.nvim_create_autocmd("CursorHold", {
            -- 		buffer = bufnr,
            -- 		callback = function()
            -- 			local opts = {
            -- 				focusable = false,
            -- 				close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
            -- 				border = "rounded",
            -- 				source = "always",
            -- 				prefix = " ",
            -- 				scope = "cursor",
            -- 			}
            -- 			vim.diagnostic.open_float(nil, opts)
            -- 		end,
            -- 	})
            -- end

            vim.diagnostic.config({
                -- signs = true,
                underline = true,
                update_in_insert = true,
                severity_sort = true,
                -- virtual_lines = true,
                virtual_text = {
                    prefix = "",
                },
                float = {
                    border = "rounded",
                    source = true,
                    header = "",
                    prefix = "",
                },
            })

            -- vim.cmd([[
            --          set signcolumn=yes
            --          autocmd CursorHold * lua vim.diagnostic.open_float(nil, { focusable = false })
            --          ]])

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
            -- TODO: change keymap
            -- vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
            -- vim.keymap.set("n", "<leader>gd", "<cmd>Glance definitions<cr>", opts)
            -- vim.keymap.set("n", "<leader>gy", "<cmd>Glance type_definitions<cr>", opts)
            -- vim.keymap.set("n", "<leader>gi", "<cmd>Glance implementations<cr>", opts)
            -- vim.keymap.set("n", "<leader>gr", "<cmd>Glance references<cr>", opts)
            vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
            -- vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
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
                ensure_installed = {
                    "lua_ls",
                    "bashls",
                    "jsonls",
                    "tailwindcss",
                    "eslint",
                },
                handlers = {
                    function(server_name)
                        require("lspconfig")[server_name].setup({
                            on_attach = on_attach,
                            handlers = handlers,
                            capabilities = capabilities,
                        })
                    end,
                },
            })
        end,
    },
    {
        "ray-x/lsp_signature.nvim",
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

            vim.api.nvim_create_autocmd("LspAttach", {
                callback = function(args)
                    local bufnr = args.buf
                    local client = vim.lsp.get_client_by_id(args.data.client_id)
                    if vim.tbl_contains({ "null-ls" }, client.name) then -- blacklist lsp
                        return
                    end
                    require("lsp_signature").on_attach({
                        -- ... setup options here ...
                    }, bufnr)
                end,
            })
        end,
    },
    {
        "lukas-reineke/lsp-format.nvim",
        config = function()
            require("lsp-format").setup({})

            require("lsp-format").setup({})
            require("lspconfig").lua_ls.setup({ on_attach = require("lsp-format").on_attach })

            -- TODO: change keymap
            -- vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, {})
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
                    local lsp_clients = vim.lsp.get_active_clients()
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
            })
        end,
    },
    {
        "nvim-lua/popup.nvim",
    },
    {
        "pmizio/typescript-tools.nvim",
        dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
        config = function()
            require("typescript-tools").setup({
                settings = {
                    separate_diagnostic_server = true,
                    tsserver_max_memory = "auto",
                    tsserver_file_preverences = {
                        includeInlayParameterNameHints = "all", -- "none" | "literals" | "all";
                        includeInlayParameterNameHintsWhenArgumentMatchesName = true,
                        includeInlayFunctionParameterTypeHints = true,
                        includeInlayVariableTypeHints = true,
                        includeInlayVariableTypeHintsWhenTypeMatchesName = true,
                        includeInlayPropertyDeclarationTypeHints = true,
                        includeInlayFunctionLikeReturnTypeHints = true,
                        includeInlayEnumMemberValueHints = true,

                        includeCompletionsForModuleExports = true,
                        quotePreference = "auto",
                    },
                    tsserver_format_options = {
                        allowRenameOfImportPath = true,
                    },
                    jsx_close_tag = {
                        enable = true,
                        filetypes = { "javascriptreact", "typescriptreact" },
                    },
                },
            })
        end,
    },
}
