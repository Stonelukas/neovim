--   https://github.com/NeogitOrg/neogit
return {
    "NeogitOrg/neogit",
    config = function()
        local neogit = require('neogit')

        neogit.setup {
            kind = 'tab',
            commit_view = {
                kind = 'tab',
            },
            integrations = {
                telescope = true,
                diffview = true,
            },
        }
    end
}
