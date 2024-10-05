return {
    {
        "akinsho/bufferline.nvim",
        enabled = false,
        version = "*",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        config = function()
            local bufferline = require("bufferline")
            require("bufferline").setup({
                options = {
                    numbers = "ordinal",
                    style_preset = bufferline.style_preset.default,
                    show_buffer_icons = true,
                    show_close_icon = true,
                    show_duplicate_prefix = true,
                    show_tab_indicators = true,
                    separator_style = "padded_slant",
                    hover = {
                        enabled = true,
                        delay = 200,
                        reveal = { "close" },
                    },
                    groups = {
                        options = {
                            toggle_hidden_on_enter = true,
                        },
                    },

                    diagnostics_indicator = function(count, level, diagnostics_dict, context)
                        local s = " "
                        for e, n in pairs(diagnostics_dict) do
                            local sym = e == "error" and " " or (e == "warning" and " " or "")
                            s = s .. n .. sym
                        end
                        return s
                    end,
                },
            })
        end,
    },
}
