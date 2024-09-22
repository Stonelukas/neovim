--   https://github.com/jackMort/ChatGPT.nvim
return {
    "jackMort/ChatGPT.nvim",
    event = 'VeryLazy',
    config = function()
        require('chatgpt').setup {}
    end
}
