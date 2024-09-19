--   https://github.com/NeogitOrg/neogit
return {
    "NeogitOrg/neogit",
    config = function()
        local neogit = require('neogit')

        neogit.setup {
            integrations = {
                telescope = true,
                diffview = true,
            },
        }
    end
}
