return {
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = function()
            local npairs = require("nvim-autopairs")
            local Rule = require("nvim-autopairs.rule")

            local cond = require("nvim-autopairs.conds")
            local brackets = { { "(", ")" }, { "[", "]" }, { "{", "}" } }
            local endwise = require("nvim-autopairs.ts-rule").endwise

            npairs.setup({
                check_ts = true,
                ts_config = {
                    lua = { "string" }, -- it will not add a pair on that treesitter node
                    javascript = { "template_string" },
                    java = false, -- don't check treesitter on java
                },
                enable_check_brackets_line = false,
            })

            npairs.add_rules(require("nvim-autopairs.rules.endwise-lua"))
            -- npairs.add_rules(require("nvim-autopairs.conds"))

            npairs.add_rules({
                -- Rule for a pair with left-side ' ' and right side ' '
                Rule(" ", " ")
                -- Pair will only occur if the conditional function returns true
                    :with_pair(function(opts)
                        -- We are checking if we are inserting a space in (), [], or {}
                        local pair = opts.line:sub(opts.col - 1, opts.col)
                        return vim.tbl_contains({
                            brackets[1][1] .. brackets[1][2],
                            brackets[2][1] .. brackets[2][2],
                            brackets[3][1] .. brackets[3][2],
                        }, pair)
                    end)
                    :with_move(cond.none())
                    :with_cr(cond.none())
                -- We only want to delete the pair of spaces when the cursor is as such: ( | )
                    :with_del(
                        function(opts)
                            local col = vim.api.nvim_win_get_cursor(0)[2]
                            local context = opts.line:sub(col - 1, col + 2)
                            return vim.tbl_contains({
                                brackets[1][1] .. "  " .. brackets[1][2],
                                brackets[2][1] .. "  " .. brackets[2][2],
                                brackets[3][1] .. "  " .. brackets[3][2],
                            }, context)
                        end
                    ),
            })
            -- For each pair of brackets we will add another rule
            for _, bracket in pairs(brackets) do
                npairs.add_rules({
                    -- Each of these rules is for a pair with left-side '( ' and right-side ' )' for each bracket type
                    Rule(bracket[1] .. " ", " " .. bracket[2])
                        :with_pair(cond.none())
                        :with_move(function(opts)
                            return opts.char == bracket[2]
                        end)
                        :with_del(cond.none())
                        :use_key(bracket[2])
                    -- Removes the trailing whitespace that can occur without this
                        :replace_map_cr(function(_)
                            return "<C-c>2xi<CR><C-c>O"
                        end),
                })
            end

            function rule2(a1, ins, a2, lang)
                npairs.add_rule(Rule(ins, ins, lang)
                    :with_pair(function(opts)
                        return a1 .. a2 == opts.line:sub(opts.col - #a1, opts.col + #a2 - 1)
                    end)
                    :with_move(cond.none())
                    :with_cr(cond.none())
                    :with_del(function(opts)
                        local col = vim.api.nvim_win_get_cursor(0)[2]
                        return a1 .. ins .. ins .. a2 ==
                        opts.line:sub(col - #a1 - #ins + 1, col + #ins + #a2)                -- insert only works for #ins == 1 anyway
                    end))
            end

            npairs.add_rule(Rule("then", "end"):end_wise(function(opts)
                return string.match(opts.line, "^%s*if") ~= nil
            end))

            npairs.add_rule(Rule(")", "end"):end_wise(function(opts)
                return string.match(opts.line, "^%s*function") ~= nil
            end))

            rule2("(", "*", ")", "ocaml")
            rule2("(*", " ", "*)", "ocaml")
            rule2("(", " ", ")")

            -- https://github.com/rstacruz/vim-closer/blob/master/autoload/closer.vim
            local get_closing_for_line = function(line)
                local i = -1
                local clo = ""

                while true do
                    i, _ = string.find(line, "[%(%)%{%}%[%]]", i + 1)
                    if i == nil then
                        break
                    end
                    local ch = string.sub(line, i, i)
                    local st = string.sub(clo, 1, 1)

                    if ch == "{" then
                        clo = "}" .. clo
                    elseif ch == "}" then
                        if st ~= "}" then
                            return ""
                        end
                        clo = string.sub(clo, 2)
                    elseif ch == "(" then
                        clo = ")" .. clo
                    elseif ch == ")" then
                        if st ~= ")" then
                            return ""
                        end
                        clo = string.sub(clo, 2)
                    elseif ch == "[" then
                        clo = "]" .. clo
                    elseif ch == "]" then
                        if st ~= "]" then
                            return ""
                        end
                        clo = string.sub(clo, 2)
                    end
                end

                return clo
            end

            -- npairs.remove_rule("(")
            -- npairs.remove_rule("{")
            -- npairs.remove_rule("[")
            --
            -- npairs.add_rule(Rule("[%(%{%[]", "")
            --     :use_regex(true)
            --     :replace_endpair(function(opts)
            --         return get_closing_for_line(opts.line)
            --     end)
            --     :end_wise(function(opts)
            --         -- Do not endwise if there is no closing
            --         return get_closing_for_line(opts.line) ~= ""
            --     end))

            local ts_conds = require("nvim-autopairs.ts-conds")

            -- press % => %% only while inside a comment or string
            npairs.add_rules({
                Rule("%", "%", "lua"):with_pair(ts_conds.is_ts_node({ "string", "comment" })),
                Rule("$", "$", "lua"):with_pair(ts_conds.is_not_ts_node({ "function" })),
            })
        end,
    },
    {
        "windwp/nvim-ts-autotag",
        ft = {
            "html",
            "javascript",
            "typescript",
            "javascriptreact",
            "typescriptreact",
            "svelte",
            "vue",
            "tsx",
            "jsx",
            "xml",
            "php",
            "markdown",
        },
        config = function()
            ---@diagnostic disable-next-line: missing-fields
            require("nvim-ts-autotag").setup({
                enable = true,
                enable_rename = true,
                enable_close = true,
                enable_close_on_slash = true,
            })
        end,
    },
}
