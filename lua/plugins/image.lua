-- Example for configuring Neovim to load user-installed installed Lua rocks:
package.path = package.path .. ";" .. vim.fn.expand("$HOME") .. "/.luarocks/share/lua/5.1/?/init.lua"
package.path = package.path .. ";" .. vim.fn.expand("$HOME") .. "/.luarocks/share/lua/5.1/?.lua"
---@module "lazy"
---@type LazySpec
return {
    { -- show images in nvim!
        "3rd/image.nvim",
        enabled = true,
        dev = false,
        ft = { "markdown", "quarto", "vimwiki" },
        -- build = false,
        cond = function()
            -- Disable on Windows system
            return vim.fn.has("win32") ~= 1
        end,
        dependencies = {
            "leafo/magick", -- that's a lua rock
        },
        config = function()
            -- Requirements
            -- https://github.com/3rd/image.nvim?tab=readme-ov-file#requirements
            -- check for dependencies with `:checkhealth kickstart`
            -- needs:
            -- sudo apt install imagemagick
            -- sudo apt install libmagickwand-dev
            -- sudo apt install liblua5.1-0-dev
            -- sudo apt install lua5.1
            -- sudo apt install luajit

            local image = require("image")
            image.setup({
                backend = "kitty",
                processor = "magick_cli",
                integrations = {
                    markdown = {
                        enabled = true,
                        only_render_image_at_cursor = true,
                        -- only_render_image_at_cursor_mode = "popup",
                        filetypes = { "markdown", "vimwiki", "quarto" },
                    },
                },
                editor_only_render_when_focused = false,
                window_overlap_clear_enabled = true,
                tmux_show_only_in_active_window = true,
                window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "scrollview", "scrollview_sign" },
                max_width = nil,
                max_height = nil,
                max_width_window_percentage = nil,
                max_height_window_percentage = 30,
                kitty_method = "normal",
            })

            local function clear_all_images()
                local bufnr = vim.api.nvim_get_current_buf()
                local images = image.get_images({ buffer = bufnr })
                for _, img in ipairs(images) do
                    img:clear()
                end
            end

            local function get_image_at_cursor(buf)
                local images = image.get_images({ buffer = buf })
                local row = vim.api.nvim_win_get_cursor(0)[1] - 1
                for _, img in ipairs(images) do
                    if img.geometry ~= nil and img.geometry.y == row then
                        local og_max_height = img.global_state.options.max_height_window_percentage
                        img.global_state.options.max_height_window_percentage = nil
                        return img, og_max_height
                    end
                end
                return nil
            end

            local create_preview_window = function(img, og_max_height)
                local buf = vim.api.nvim_create_buf(false, true)
                local win_width = vim.api.nvim_get_option_value("columns", {})
                local win_height = vim.api.nvim_get_option_value("lines", {})
                local win = vim.api.nvim_open_win(buf, true, {
                    relative = "editor",
                    style = "minimal",
                    width = win_width,
                    height = win_height,
                    row = 0,
                    col = 0,
                    zindex = 1000,
                })
                vim.keymap.set("n", "q", function()
                    vim.api.nvim_win_close(win, true)
                    img.global_state.options.max_height_window_percentage = og_max_height
                end, { buffer = buf })
                return { buf = buf, win = win }
            end

            local handle_zoom = function(bufnr)
                local img, og_max_height = get_image_at_cursor(bufnr)
                if img == nil then
                    return
                end

                local preview = create_preview_window(img, og_max_height)
                image.hijack_buffer(img.path, preview.win, preview.buf)
            end

            vim.keymap.set("n", "<leader>io", function()
                local bufnr = vim.api.nvim_get_current_buf()
                handle_zoom(bufnr)
            end, { buffer = true, desc = "image [o]pen" })

            vim.keymap.set("n", "<leader>ic", clear_all_images, { desc = "image [c]lear" })
        end,
    },

    { -- requires plugins in lua/plugins/treesitter.lua and lua/plugins/lsp.lua
        -- for complete functionality (language features)
        "quarto-dev/quarto-nvim",
        ft = { "quarto" },
        dev = false,
        opts = {
            lspFeatures = {
                languages = { "r", "python", "julia", "lua" },
            },
        },
        dependencies = {
            {
                "quarto-dev/quarto-vim",
                ft = "quarto",
                dependencies = { "vim-pandoc/vim-pandoc-syntax" },
            },
            -- for language features in code cells
            -- configured in lua/plugins/lsp.lua and
            -- added as a nvim-cmp source in lua/plugins/completion.lua
            { "jmbuhr/otter.nvim" },
            "neovim/nvim-lspconfig",
        },
    },

    { -- directly open ipynb files as quarto docuements
        -- and convert back behind the scenes
        "GCBallesteros/jupytext.nvim",
        opts = {
            custom_language_formatting = {
                python = {
                    extension = "qmd",
                    style = "quarto",
                    force_ft = "quarto",
                },
                r = {
                    extension = "qmd",
                    style = "quarto",
                    force_ft = "quarto",
                },
            },
        },
    },

    { -- send code from python/r/qmd documets to a terminal or REPL
        -- like ipython, R, bash
        "jpalardy/vim-slime",
        dev = false,
        init = function()
            vim.b["quarto_is_python_chunk"] = false
            Quarto_is_in_python_chunk = function()
                require("otter.tools.functions").is_otter_language_context("python")
            end

            vim.cmd([[
      let g:slime_dispatch_ipython_pause = 100
      function SlimeOverride_EscapeText_quarto(text)
      call v:lua.Quarto_is_in_python_chunk()
      if exists('g:slime_python_ipython') && len(split(a:text,"\n")) > 1 && b:quarto_is_python_chunk && !(exists('b:quarto_is_r_mode') && b:quarto_is_r_mode)
      return ["%cpaste -q\n", g:slime_dispatch_ipython_pause, a:text, "--", "\n"]
      else
      if exists('b:quarto_is_r_mode') && b:quarto_is_r_mode && b:quarto_is_python_chunk
      return [a:text, "\n"]
      else
      return [a:text]
      end
      end
      endfunction
      ]])

            vim.g.slime_target = "neovim"
            vim.g.slime_no_mappings = true
            vim.g.slime_python_ipython = 1
        end,
        config = function()
            vim.g.slime_input_pid = false
            vim.g.slime_suggest_default = true
            vim.g.slime_menu_config = false
            vim.g.slime_neovim_ignore_unlisted = true

            local function mark_terminal()
                local job_id = vim.b.terminal_job_id
                vim.print("job_id: " .. job_id)
            end

            local function set_terminal()
                vim.fn.call("slime#config", {})
            end
            vim.keymap.set("n", "<leader>cm", mark_terminal, { desc = "[m]ark terminal" })
            vim.keymap.set("n", "<leader>cs", set_terminal, { desc = "[s]et terminal" })
        end,
    },

    { -- paste an image from the clipboard or drag-and-drop
        "HakonHarnes/img-clip.nvim",
        event = "BufEnter",
        ft = { "markdown", "quarto", "latex" },
        opts = {
            default = {
                dir_path = "img",
            },
            filetypes = {
                markdown = {
                    url_encode_path = true,
                    template = "![$CURSOR]($FILE_PATH)",
                    drag_and_drop = {
                        download_images = false,
                    },
                },
                quarto = {
                    url_encode_path = true,
                    template = "![$CURSOR]($FILE_PATH)",
                    drag_and_drop = {
                        download_images = false,
                    },
                },
            },
        },
        config = function(_, opts)
            require("img-clip").setup(opts)
            vim.keymap.set("n", "<leader>ii", ":PasteImage<cr>", { desc = "insert [i]mage from clipboard" })
        end,
    },

    { -- preview equations
        "jbyuki/nabla.nvim",
        keys = {
            { "<leader>qm", ':lua require"nabla".toggle_virt()<cr>', desc = "toggle [m]ath equations" },
        },
    },
}
