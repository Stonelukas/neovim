--   https://github.com/stevearc/overseer.nvim
return {
    "stevearc/overseer.nvim",
    opts = {},
    config = function()
        require('overseer').setup{
            templates = { 'builtin', 'user.cpp_build' },
        }
    end
}
