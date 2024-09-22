--   https://github.com/nvimtools/hydra.nvim
return {
    "nvimtools/hydra.nvim",
    config = function()
        local hydra = require('hydra')



        hydra.setup {
            color = 'red',
        }

        require('plugins.utils.hydra')
    end
}  

