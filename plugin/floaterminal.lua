local state = {
    floating = {
        buf = -1,
        win = -1
    }
}
local function create_floating_window(opts)
    opts = opts or {}
    local width = opts.width or math.floor(vim.o.columns * 0.8)
    local height = opts.height or math.floor(vim.o.lines * 0.8)

    -- Calculate the position to center the window
    local row = opts.row or math.floor((vim.o.lines - height) / 2)
    local col = opts.col or math.floor((vim.o.columns - width) / 2)

    -- create a buffer
    local buf = nil
    if vim.api.nvim_buf_is_valid(opts.buf) then
        buf = opts.buf
    else 
        buf = vim.api.nvim_create_buf(false, true)
    end

    -- define window configuration
    local config = {
        style = "minimal",
        relative = "editor",
        width = width,
        height = height,
        row = row,
        col = col,
        border = "rounded",
    }

    -- create the floating window
    local win = vim.api.nvim_open_win(buf, true, config)
    return { buf = buf, win = win }
end

local toggleTerminal = function()
    if not vim.api.nvim_win_is_valid(state.floating.win) then
        state.floating = create_floating_window { buf = state.floating.buf }
        if vim.bo[state.floating.buf] ~= "terminal" then
            vim.cmd.term()
        end
    else
        vim.api.nvim_win_hide(state.floating.win)
    end
end

-- example usage
-- Create a floating window with default dimensions
vim.api.nvim_create_user_command("Floaterminal", toggleTerminal, {})
vim.keymap.set( { "n", "t" }, "<m-t>", toggleTerminal, { desc = "Toggle Floaterminal" })
