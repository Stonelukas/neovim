local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local function get_session_name()
    local name = vim.fn.getcwd()
    local branch = vim.trim(vim.fn.system("git branch --show-current"))
    if vim.v.shell_error == 0 then
        return name .. branch
    else 
        return name 
    end 
end
-- SESSIONS
autocmd("VimLeavePre", {
    callback = function()
        require('resession').save("last")
    end,
})

-- autosave and open based on directories
autocmd("VimEnter", {
    callback = function()
        -- Only load the session if nvim was started with no args
        if vim.fn.argc(-1) == 0 then
            -- Save these to a different directory, so our manual sessions don't get polluted
            require('resession').load(vim.fn.getcwd(), { dir = "dirsession", silence_errors = true })
        end
    end,
    nested = true
})
autocmd("VimLeavePre", {
    callback = function()
        require('resession').save(vim.fn.getcwd(), { dir = "dirsession", notify = false })
    end,
})

-- autosave and open based on git
autocmd("VimEnter", {
    callback = function()
        -- Only load the session if nvim was started with no args
        if vim.fn.argc(-1) == 0 then
            -- Save these to a different directory, so our manual sessions don't get polluted
            require('resession').load(get_session_name(), { dir = "dirsession", silence_errors = true })
        end
    end,
})
autocmd("VimLeavePre", {
    callback = function()
        require('resession').save(get_session_name(), { dir = "dirsession", notify = false })
    end,
})


-- NVIM-TREE
-- auto close
