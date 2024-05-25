return {
    "rmagatti/auto-session",
    config = function()
        require("auto-session").setup({
            auto_session_use_git_branch = true,
            session_lens = {
                buftypes_to_ignore = {},
                load_on_setup = true,
                theme_conf = { border = true },
                previewer = true,
            },
        })
        vim.keymap.set("n", "<leader>ls", require("auto-session.session-lens").search_session, {
            noremap = true,
        })
    end,
}
