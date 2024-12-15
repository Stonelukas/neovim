return {
	{
		"uga-rosa/ccc.nvim",
        enabled = false,
		config = function()
			local ccc = require("ccc")
			local mapping = ccc.mapping

			ccc.setup({
				lsp = true,
				highlighter = {
					auto_enable = true,
					lsp = true,
					update_insert = true,
				},
				highlight_mode = "virtual",
				recognize = {
					input = true,
					output = true,
				},
				preserve = true,
				outputs = {
					ccc.output.hex,
					ccc.output.hex_short,
					ccc.output.css_rgb,
					ccc.output.css_hsl,
					ccc.output.float,
				},
				mappings = mapping,
			})
		end,
	},
}
