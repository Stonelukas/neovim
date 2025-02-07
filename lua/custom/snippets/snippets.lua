require("luasnip.session.snippet_collection").clear_snippets("snippets")

local ls = require("luasnip")
local types = require("luasnip.util.types")
local s = ls.snippet
local i = ls.insert_node
local t = ls.text_node
local r = ls.restore_node
local d = ls.dynamic_node
local f = ls.function_node
local c = ls.choice_node
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local rep = require("luasnip.extras").rep
local fmt = require("luasnip.extras.fmt").fmt
local function copy(args)
    return args[1]
end

local date_input = function(args, snip, old_state, fmt)
    local fmt_date = fmt or "%Y-%m-%d"
    return sn(nil, i(1, os.date(fmt_date)))
end

-- 'recursive' dynamic snippet. Expands to some text followed by itself.
local rec_ls
rec_ls = function()
    return sn(
        nil,
        c(1, {
            -- Order is important, sn(...) first would cause infinite loop of expansion.
            t(""),
            sn(nil, { t({ "", "\t\\item " }), i(1), d(2, rec_ls, {}) }),
        })
    )
end

local same = function(index)
    return f(function(arg)
        return arg[1]
    end, { index })
end

ls.add_snippets("all", {
    s("sametest", fmt([[example: {}, function: {}]], { i(1), rep(1) })),
    s("class", {
        -- Choice: Switch between two different Nodes, first parameter is its position, second a list of nodes.
        c(1, {
            t("Public "),
            t("Private "),
        }),
        t("class "),
        i(2),
        t(" "),
        c(3, {
            t("{"),
            -- sn: Nested Snippet. Instead of a trigger, it has a position, just like insertNodes. !!! These don't expect a 0-node!!!!
            -- Inside Choices, Nodes don't need a position as the choice node is the one being jumped to.
            sn(nil, {
                t("extends "),
                -- restoreNode: stores and restores nodes.
                -- pass position, store-key and nodes.
                r(1, "other_class", i(1)),
                t(" {"),
            }),
            sn(nil, {
                t("implements "),
                -- no need to define the nodes for a given key a second time.
                r(1, "other_class"),
                t(" {"),
            }),
        }),
        t({ "", "\t" }),
        i(0),
        t({ "", "}" }),
    }),
    s(
        "curtime",
        f(function()
            return os.date("%D -%H:%M")
        end)
    ),
})
ls.add_snippets("lua", {
    s(
        "require",
        fmt([[local {} = require("{}")]], {
            f(function(import_name)
                local parts = vim.split(import_name[1][1], ".", true)
                return parts[#parts] or ""
            end, { 1 }),
            i(1),
        })
    ),
})
ls.add_snippets("rust", {
    s(
        "modtest",
        fmt(
            [[
           #[cfg(test)]
           mod test {{
           {}

               {}
           }}
       ]],
            {
                c(1, { t("      use super::*;"), t("") }),
                i(0),
            }
        )
    ),
})
