local function opts(desc)
    return {
        desc = "" .. desc,
        noremap = true,
        silent = true,
        nowait = true,
    }
end
local builtin = require("telescope.builtin")
local map = vim.keymap.set
local telescope = require("telescope")

-- recent files extension
require("telescope").load_extension("recent-files")

map("n", "<leader>f.", function()
    require("telescope").extensions["recent-files"].recent_files({})
end, {
    desc = "recent files",
    noremap = true,
    silent = true,
})

-- project extension
require("telescope").load_extension("project")

map("n", "<leader>fP", function()
    require("telescope").extensions.project.project({
        display_type = "full",
    })
end, {
    noremap = true,
    silent = true,
})

-- telescope file browser extension
require("telescope").load_extension("file_browser")

map("n", "<space>fb", function()
    require("telescope").extensions.file_browser.file_browser()
end)

-- telescope menu
require("telescope").load_extension("menu")

-- telescope zoxide
telescope.load_extension("zoxide")

map("n", "<leader>cd", telescope.extensions.zoxide.list)

-- telescope lazy extensions
require("telescope").load_extension("lazy")

map("n", "<leader>ll", ":Telescope lazy<CR>", {
    noremap = true,
    desc = "Lazy Plugins",
})

-- egrepify extensions
require("telescope").load_extension("egrepify")

-- scope extensions
require("telescope").load_extension("scope")

-- noice extension
require("telescope").load_extension("noice")

-- aerial extension
require("telescope").load_extension("aerial")

-- workspaces extension
require("telescope").load_extension("workspaces")

-- cder extension
require("telescope").load_extension("cder")

-- env extension
require("telescope").load_extension("env")

-- text-case extension
require("telescope").load_extension("textcase")

-- neoclip extension
require("telescope").load_extension("neoclip")

-- package-info extension
require("telescope").load_extension("package_info")

-- pathogen
require("telescope").load_extension("pathogen")

-- Github CLI
require("telescope").load_extension("gh")

-- Lazygit
require("telescope").load_extension("lazygit")

-- Repo
require("telescope").load_extension("repo")

-- Node Modules
require("telescope").load_extension("node_modules")

-- Headings
require("telescope").load_extension("heading")

-- Emojis
require("telescope").load_extension("emoji")

-- File Switcher
require("telescope").load_extension("switch")
map("n", "<leader>fs", require("telescope").extensions.switch.switch, opts("Switch to a Project file"))

-- Neoclip and Macroscope
require("telescope").load_extension("neoclip")
require("telescope").load_extension("macroscope")
map("n", "<leader>fc", require("telescope").extensions.neoclip.default, opts("Neoclip"))
map("n", "<leader>fm", require("telescope").extensions.macroscope.default, opts("Macroscope"))

-- Scriptnames
require("telescope").load_extension("scriptnames")

-- yanky
require("telescope").load_extension("yank_history")

-- undo
require("telescope").load_extension("undo")

-- docker
require("telescope").load_extension("docker")

-- helpgrep
require("telescope").load_extension("helpgrep")

-- lazy
require("telescope").load_extension("lazy")

-- lazy-pugins config
require("telescope").load_extension("lazy_plugins")
map("n", "<leader>fl", "<cmd>Telescope lazy_plugins<cr>", opts("Lazy Plugins Files"))

-- resession
require("telescope").load_extension("resession")

-- scope
require("telescope").load_extension("scope")

-- tasks
local default = require("telescope").extensions.tasks.generators.default
default.all()
require("telescope").load_extension("tasks")

-- picker-list -  INFO: needs to be last
require("telescope").load_extension("picker_list")

require("telescope").load_extension("themes")
require("telescope").load_extension("terms")
