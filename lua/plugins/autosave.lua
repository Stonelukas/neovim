return {
    "okuuva/auto-save.nvim",
    cmd = "ASToggle",
    event = { "InsertLeave", "TextChanged" },
    keys = {
        { "<leader>as", "<cmd>ASToggle<cr>", desc = "AutoSave" },
    },
    opts = {
        enabled = true,
        trigger_events = {                                 -- See :h events

            immediate_save = { "BufLeave", "FocusLost" },  -- vim events that trigger an immediate save
            defer_save = { "InsertLeave", "TextChanged" }, -- vim events that trigger a deferred save (saves after `debounce_delay`)

            cancel_deferred_save = { "InsertEnter" },      -- vim events that cancel a pending deferred save
        },
        conditions = function(buf)
            local fn = vim.fn

            -- don't save for special-buffers
            if fn.getbufvar(buf, "buftype") ~= "" then
                return false
            end
            return true
        end,
        noautocmd = false,
        lockmarks = false,
        write_all_buffers = false,
        debounce_delay = 3000,
    },
}
