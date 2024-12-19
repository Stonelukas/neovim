return {
    {
        "kevinhwang91/nvim-ufo",
        enabled = true,
        dependencies = {
            "kevinhwang91/promise-async",
            {
                "luukvbaal/statuscol.nvim",
                config = function()
                    local builtin = require("statuscol.builtin")
                    require("statuscol").setup({
                        relculright = true,
                        segments = {
                            { text = { "%s" },             click = "v:lua.ScSa" },
                            { text = { builtin.lnumfunc }, click = "v:lua.ScLa" },
                            {
                                text = { " ", builtin.foldfunc, "  " },
                                condition = { true, builtin.not_empty },
                                click = "v:lua.ScFa",
                            },
                            {
                                sign = { name = { "diagnostic" }, maxwidth = 2, auto = true },
                                click = "v:lua.scsa",
                            },
                        },
                    })
                end,
            },
        },
        event = "BufReadPost",
        opts = {
            open_fold_hl_timeout = 400,
            -- close_fold_kinds_for_ft = { "imports", "comment" },
            preview = {
                win_config = {
                    border = { "", "─", "", "", "", "─", "", "" },
                    winhighlight = "Normal:Folded",
                    winblend = 0,
                },
                mappings = {
                    scrollU = "<C-u>",
                    scrollD = "<C-d>",
                    jumpTop = "[",
                    jumpBot = "]",
                },
            },
            provider_selector = function(bufnr, filetype, buftype)
                return { "treesitter", "indent" }
            end,
        },
        config = function(_, opts)
            local handler = function(virtText, lnum, endLnum, width, truncate)
                local newVirtText = {}
                local totalLines = vim.api.nvim_buf_line_count(0)
                local foldedLines = endLnum - lnum
                local suffix = ("  %d %d%%"):format(foldedLines, foldedLines / totalLines * 100)
                local sufWidth = vim.fn.strdisplaywidth(suffix)
                local targetWidth = width - sufWidth
                local curWidth = 0
                for _, chunk in ipairs(virtText) do
                    local chunkText = chunk[1]
                    local chunkWidth = vim.fn.strdisplaywidth(chunkText)
                    if targetWidth > curWidth + chunkWidth then
                        table.insert(newVirtText, chunk)
                    else
                        chunkText = truncate(chunkText, targetWidth - curWidth)
                        local hlGroup = chunk[2]
                        table.insert(newVirtText, { chunkText, hlGroup })
                        chunkWidth = vim.fn.strdisplaywidth(chunkText)
                        -- str width returned from truncate() may less than 2nd argument, need padding
                        if curWidth + chunkWidth < targetWidth then
                            suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
                        end
                        break
                    end
                    curWidth = curWidth + chunkWidth
                end
                local rAlignAppndx = math.max(math.min(vim.opt.textwidth["_value"], width - 1) - curWidth - sufWidth, 0)
                suffix = (" "):rep(rAlignAppndx) .. suffix
                table.insert(newVirtText, { suffix, "MoreMsg" })
                return newVirtText
            end

            local handler2 = function(virt_text, lnum, end_lnum, width, truncate)
                local newVirtText = {}
                local _end = end_lnum - 1
                local final_text = vim.trim(vim.api.nvim_buf_get_text(0, _end, 0, _end, -1, {})[1])
                local totalLines = vim.api.nvim_buf_line_count(0)
                local foldedLines = end_lnum - lnum
                local suffix = final_text:format(end_lnum - lnum)
                local suffix2 = ("  %d %d%%"):format(foldedLines, foldedLines / totalLines * 100)
                local sufWidth = vim.fn.strdisplaywidth(suffix)
                local targetWidth = width - sufWidth
                local curWidth = 0
                for _, chunk in ipairs(virt_text) do
                    local chunkText = chunk[1]
                    local chunkWidth = vim.fn.strdisplaywidth(chunkText)
                    if targetWidth > curWidth + chunkWidth then
                        table.insert(newVirtText, chunk)
                    else
                        chunkText = truncate(chunkText, targetWidth - curWidth)
                        local hl_group = chunk[2]
                        table.insert(newVirtText, { chunkText, hl_group })
                        chunkWidth = vim.fn.strdisplaywidth(chunkText)
                        -- str width returned from truncate() may less than 2nd argument, need padding
                        if curWidth + chunkWidth < targetWidth then
                            suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
                        end
                        break
                    end
                    curWidth = curWidth + chunkWidth
                end
                local rAlignAppndx = math.max(math.min(vim.opt.textwidth["_value"], width - 1) - curWidth - sufWidth, 0)
                suffix2 = (" "):rep(rAlignAppndx) .. suffix2
                table.insert(newVirtText, { ' ⋯ ', 'NonText' })
                table.insert(newVirtText, { suffix, 'TSPunctBracket' })
                table.insert(newVirtText, { suffix2, 'MoreMsg' })
                return newVirtText
            end

            opts["fold_virt_text_handler"] = handler2
            require("ufo").setup(opts)

            vim.keymap.set("n", "zR", function()
                require("ufo").openAllFolds()
            end)
            vim.keymap.set("n", "zM", function()
                require("ufo").closeAllFolds()
            end)
            vim.keymap.set("n", "zr", require("ufo").openFoldsExceptKinds)
            vim.keymap.set("n", "K", function()
                local winid = require("ufo").peekFoldedLinesUnderCursor()
                if not winid then
                    vim.lsp.buf.hover()
                end
            end)
        end,
    },

    -- Folding preview, by default h and l keys are used.
    -- On first press of h key, when cursor is on a closed fold, the preview will be shown.
    -- On second press the preview will be closed and fold will be opened.
    -- When preview is opened, the l key will close it and open fold. In all other cases these keys will work as usual.
    {
        "anuvyklack/fold-preview.nvim",
        enabled = false,
        dependencies = "anuvyklack/keymap-amend.nvim",
        opts = {
            border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
        },
        config = true,
    },
}
