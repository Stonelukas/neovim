-- Set the global leader keys to a space for easier access in command mode
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Define the path where lazy.nvim will be stored locally
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
-- Check if lazy.nvim is already downloaded, if not, clone it from GitHub
if not vim.uv.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none", -- This option minimizes data transfer to only essential information
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",    -- Ensures cloning from the stable branch
        lazypath,
    })
end

-- Add lazy.nvim to the runtime path to allow using `require` on it
---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Initialize lazy.nvim with the specified configuration directory
require("lazy").setup({
    spec = {
        import = "plugins",
    },
    default = { version = nil },
    -- install = { missing = true, colorscheme = { 'tokyonight', 'material' } },
    install = { missing = true, colorscheme = { "nvchad" } },
    checker = {
        enabled = true,
        notify = true,
    },
    ui = {
        border = "rounded",
        icons = {
            cmd = "⌘",
            config = "🛠",
            event = "📅",
            ft = "📂",
            init = "⚙",
            keys = "🗝",
            plugin = "🔌",
            runtime = "💻",
            source = "📄",
            start = "🚀",
            task = "📌",
            lazy = "💤 ",
        },
    },
    change_detection = {
        notify = false, -- Disable notifications for changes
    },
})

vim.keymap.set('n', '<leader>z', '<cmd>Lazy<cr>', { desc = 'Lazy' })

vim.api.nvim_create_autocmd("User", {
    pattern = "VeryLazy",
    callback = function()
        require "core.keymaps"
    end,
})

require 'core.options'
require "core.autocmds"

for _, v in ipairs(vim.fn.readdir(vim.g.base46_cache)) do
    dofile(vim.g.base46_cache .. v)
end

-- Append 'c' to shortmess to avoid showing extra completion messages
vim.opt.shortmess:append("c")
