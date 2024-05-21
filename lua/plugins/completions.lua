---@diagnostic disable: unused-local
return {
    {
        "hrsh7th/cmp-nvim-lsp",
    },
    {
        "petertriho/cmp-git",
    },
    {
        "onsails/lspkind.nvim",
    },
    {
        "nvim-tree/nvim-web-devicons",
    },
    {
        "danymat/neogen",
        config = true,
    },
    {
        "onsails/diaglist.nvim",
    },
    {
        "L3MON4D3/LuaSnip",
        run = "make install_jsregexp",
        dependencies = {
            "saadparwaiz1/cmp_luasnip",
            "rafamadriz/friendly-snippets",
        },
    },
    {
        "hrsh7th/nvim-cmp",
        event = { "InsertEnter", "CmdlineEnter" },
        config = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")
            local lspkind = require("lspkind")
            local types = require("cmp.types")
            local str = require("cmp.utils.str")

            local t = function(str)
                return vim.api.nvim_replace_termcodes(str, true, true, true)
            end

            local cmp_kinds = {
                Text = "  ",
                Method = "  ",
                Function = "  ",
                Constructor = "  ",
                Field = "  ",
                Variable = "  ",
                Class = "  ",
                Interface = "  ",
                Module = "  ",
                Property = "  ",
                Unit = "  ",
                Value = "  ",
                Enum = "  ",
                Keyword = "  ",
                Snippet = "  ",
                Color = "  ",
                File = "  ",
                Reference = "  ",
                Folder = "  ",
                EnumMember = "  ",
                Constant = "  ",
                Struct = "  ",
                Event = "  ",
                Operator = "  ",
                TypeParameter = "  ",
            }

            require("luasnip.loaders.from_vscode").lazy_load()

            cmp.setup({
                snippet = {
                    expand = function(args)
                        require("luasnip").lsp_expand(args.body)
                    end,
                },
                view = {
                    entries = { name = "custom", selection_order = "near_cursor" },
                },
                window = {
                    completion = {
                        winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
                        col_offset = -3,
                        side_padding = 0,
                    },
                    documentation = cmp.config.window.bordered(),
                },
                formatting = {
                    --[[ fields = { "kind", "abbr", "menu" },
                    format = function(entry, vim_item)
                        local kind =
                            require("lspkind").cmp_format({ mode = "symbol_text", maxwidth = 50 })(entry, vim_item)
                        local strings = vim.split(kind.kind, "%s", { trimempty = true })
                        kind.kind = " " .. (strings[1] or "") .. " "
                        kind.menu = "    (" .. (strings[2] or "") .. ")"

                        return kind
                    end,]]
                    --

                    fields = {
                        cmp.ItemField.Abbr,
                        cmp.ItemField.Kind,
                        cmp.ItemField.Menu,
                    },
                    format = lspkind.cmp_format({
                        mode = "symbol_text",
                        maxwidth = 60,
                        wllipsis_char = "...",
                        show_labelDetails = true,
                        before = function(entry, vim_item)
                            -- Get the full snippet (and only keep first line)
                            local word = entry:get_insert_text()
                            if entry.completion_item.insertTextFormat == types.lsp.InsertTextFormat.Snippet then
                                word = vim.lsp.util.parse_snippet(word)
                            end
                            word = str.oneline(word)

                            -- concatenates the string
                            -- local max = 50
                            -- if string.len(word) >= max then
                            -- 	local before = string.sub(word, 1, math.floor((max - 3) / 2))
                            -- 	word = before .. "..."
                            -- end

                            if
                                entry.completion_item.insertTextFormat == types.lsp.InsertTextFormat.Snippet
                                and string.sub(vim_item.abbr, -1, -1) == "~"
                            then
                                word = word .. "~"
                            end
                            vim_item.abbr = word

                            return vim_item
                        end,
                        menu = {
                            buffer = "[Buffer]",
                            nvim_lsp = "[LSP]",
                            luasnip = "[LuaSnip]",
                            nvim_lua = "[Lua]",
                        },
                    }),
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<C-e>"] = cmp.mapping.abort(),
                    ["<CR>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            if luasnip.expandable() then
                                luasnip.expand()
                            else
                                cmp.confirm({
                                    behavior = cmp.ConfirmBehavior.Replace,
                                    select = true,
                                })
                            end
                        else
                            fallback()
                        end
                    end),
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.locally_jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                }),
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "luasnip" }, -- For luasnip users.
                    { name = "cmp_git" }, -- For luasnip users.
                }, {
                    { name = "buffer", Keyword = 5, max_item_count = 5 },
                }),
            })
            cmp.setup.filetype("gitcommit", {
                sources = cmp.config.sources({
                    { name = "git" },
                }, {
                    { name = "buffer" },
                }),
            })
            require("cmp_git").setup()
            require("cmp").setup.cmdline(":", {
                sources = {
                    { name = "cmdline", keyword_length = 2 },
                },
            })
            require("diaglist").init({
                debug = false,
                debounce_ms = 150,
            })
            -- gray
            vim.api.nvim_set_hl(0, "CmpItemAbbrDeprecated", { bg = "NONE", strikethrough = true, fg = "#808080" })
            -- blue
            vim.api.nvim_set_hl(0, "CmpItemAbbrMatch", { bg = "NONE", fg = "#569CD6" })
            vim.api.nvim_set_hl(0, "CmpItemAbbrMatchFuzzy", { link = "CmpIntemAbbrMatch" })
            -- light blue
            vim.api.nvim_set_hl(0, "CmpItemKindVariable", { bg = "NONE", fg = "#9CDCFE" })
            vim.api.nvim_set_hl(0, "CmpItemKindInterface", { link = "CmpItemKindVariable" })
            vim.api.nvim_set_hl(0, "CmpItemKindText", { link = "CmpItemKindVariable" })
            -- pink
            vim.api.nvim_set_hl(0, "CmpItemKindFunction", { bg = "NONE", fg = "#C586C0" })
            vim.api.nvim_set_hl(0, "CmpItemKindMethod", { link = "CmpItemKindFunction" })
            -- front
            vim.api.nvim_set_hl(0, "CmpItemKindKeyword", { bg = "NONE", fg = "#D4D4D4" })
            vim.api.nvim_set_hl(0, "CmpItemKindProperty", { link = "CmpItemKindKeyword" })
            vim.api.nvim_set_hl(0, "CmpItemKindUnit", { link = "CmpItemKindKeyword" })
        end,
    },
}
