return {
	{
		"aznhe21/actions-preview.nvim",
		cond = true,
		config = function()
			local hl = require("actions-preview.highlight")
			require("actions-preview").setup({
				highlight_command = {
					-- Highlight diff using delta: https://github.com/dandavison/delta
					-- The argument is optional, in which case "delta" is assumed to be
					-- specified.
					hl.delta("path/to/delta --option1 --option2"),
					-- You may need to specify "--no-gitconfig" since it is dependent on
					-- the gitconfig of the project by default.
					-- hl.delta("delta --no-gitconfig --side-by-side"),

					-- Highlight diff using diff-so-fancy: https://github.com/so-fancy/diff-so-fancy
					-- The arguments are optional, in which case ("diff-so-fancy", "less -R")
					-- is assumed to be specified. The existence of less is optional.
					hl.diff_so_fancy("path/to/diff-so-fancy --option1 --option2"),

					-- Highlight diff using diff-highlight included in git-contrib.
					-- The arguments are optional; the first argument is assumed to be
					-- "diff-highlight" and the second argument is assumed to be
					-- `{ colordiff = "colordiff", pager = "less -R" }`. The existence of
					-- colordiff and less is optional.
					hl.diff_highlight("path/to/diff-highlight", { colordiff = "path/to/colordiff" }),

					-- And, you can use any command to highlight diff.
					-- Define the pipeline by `hl.commands`.
					hl.commands({
						{ cmd = "command-to-diff-highlight" },
						-- `optional` can be used to define that the command is optional.
						{ cmd = "less -R", optional = true },
					}),
					-- If you use optional `less -R` (or similar command), you can also use `hl.with_pager`.
					hl.with_pager("command-to-diff-highlight"),
					-- hl.with_pager("command-to-diff-highlight", "custom-pager"),
				},
				diff = {
					algorithm = "patience",
					ignore_whitespace = true,
				},
				telescope = {
					sorting_strategy = "ascending",
					layout_strategy = "vertical",
					layout_config = {
						width = 0.8,
						height = 0.9,
						prompt_position = "top",
						preview_cutoff = 20,
						preview_height = function(_, _, max_lines)
							return max_lines - 15
						end,
					},
				},
			})
			vim.keymap.set({ "v", "n" }, "<leader>ap", require("actions-preview").code_actions)
		end,
	},
}
