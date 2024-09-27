--   https://github.com/folke/flash.nvim

return {
	"folke/flash.nvim",
	event = "VeryLazy",
	opts = {
		mode = "fuzzy",
		jump = {
			history = true,
			register = true,
			nohlsearch = true,
			autojump = true,
		},
		label = {
			stlye = "overlay",
			rainbow = {
				enabled = true,
			},
		},
        exclude = {
          "notify",
          "cmp_menu",
          "noice",
          "flash_prompt",
          "cmp",
          "notify",
          "telescope",
          "toggleterm",
          "neogit",
          "NeogitStatus",
          "NeogitCommitMessage",
          "NeogitCommitView",
          "NeogitNotification",
          "NeogitFileHistory",
          "NeogitLogView",
          "NeogitPopup",
          "NeogitHunkHeader",

        },
		modes = {
			search = {
				enabled = true,
			},
			char = {
                jump_labels = true,
            },
		},
	},
    -- stylua: ignore
    keys = {
        { "s",     mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash" },
        { "S",     mode = { "n", "x", "o" }, function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
        { "r",     mode = "o",               function() require("flash").remote() end,            desc = "Remote Flash" },
        { "R",     mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
        { "<c-s>", mode = { "c" },           function() require("flash").toggle() end,            desc = "Toggle Flash Search" },
    }
,
}
