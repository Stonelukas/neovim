return {
	"axkirillov/easypick.nvim",
	config = function()
		local easypick = require("easypick")
        local list_make_targets = [[
        make -qp |
        awk -F':' '/^[a-zA-Z0-9][^$#\/\t=]*:([^=]|$)/ {split($1,A,/ /);for(i in A)print A[i]}' |
        grep -wv Makefile
        ]]

		easypick.setup({
			pickers = {
				-- add your custom pickers here
				-- below you can find some examples of what those can look like

				-- list files inside current folder with default previewer
				{
					-- name for your custom picker, that can be invoked using :Easypick <name> (supports tab completion)
					name = "ls",
					-- the command to execute, output has to be a list of plain text entries
					command = "ls",
					-- specify your custom previwer, or use one of the easypick.previewers
					previewer = easypick.previewers.default(),
				},

				-- list files that have conflicts with diffs in preview
				{
					name = "conflicts",
					command = "git diff --name-only --diff-filter=U --relative",
					previewer = easypick.previewers.file_diff(),
				},
                {
                    -- TODO: Floatterm
                    name = "make_targets",
                    command = list_make_targets,
                    action = easypick.actions.nvim_commandf("FloatermNew make %s"),
                    opts = require('telescope.themes').get_dropdown()
                },
			},
		})
	end,
}
