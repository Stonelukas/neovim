return {
	{
		"rcarriga/nvim-notify",
		cond = false,
		config = function()
			require("notify")
			vim.notify = require("notify")
			require("notify").setup({
				background_colour = "#000000",
				icons = {
					DEBUG = "",
					ERROR = "",
					INFO = "",
					TRACE = "✎",
					WARN = "",
				},
				level = 2,
				minimum_width = 50,
				render = "default",
				stages = "fade_in_slide_out",
				time_formats = {
					notification = "%T",
					notification_history = "%FT%T",
				},
				timeout = 5000,
				top_down = true,
			})

			-- table from lsp severity to vim severity.
			local severity = {
				"error",
				"warn",
				"info",
				"info", -- map both hint and info to info?
			}
			vim.lsp.handlers["window/showMessage"] = function(err, method, params, client_id)
				vim.notify(method.message, severity[params.type])
			end

			-- Utility functions shared between progress reports for LSP and DAP

			local client_notifs = {}

			local function get_notif_data(client_id, token)
				if not client_notifs[client_id] then
					client_notifs[client_id] = {}
				end

				if not client_notifs[client_id][token] then
					client_notifs[client_id][token] = {}
				end

				return client_notifs[client_id][token]
			end

			local spinner_frames = { "⣾", "⣽", "⣻", "⢿", "⡿", "⣟", "⣯", "⣷" }

			local function update_spinner(client_id, token)
				local notif_data = get_notif_data(client_id, token)

				if notif_data.spinner then
					local new_spinner = (notif_data.spinner + 1) % #spinner_frames
					notif_data.spinner = new_spinner

					notif_data.notification = vim.notify(nil, nil, {
						hide_from_history = true,
						icon = spinner_frames[new_spinner],
						replace = notif_data.notification,
					})

					vim.defer_fn(function()
						update_spinner(client_id, token)
					end, 100)
				end
			end

			local function format_title(title, client_name)
				return client_name .. (#title > 0 and ": " .. title or "")
			end

			local function format_message(message, percentage)
				return (percentage and percentage .. "%\t" or "") .. (message or "")
			end
		end,
	},
}
