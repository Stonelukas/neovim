--- This module configures various AI-related plugins for Neovim.
--- It includes settings for avante.nvim, codeium.vim, nvim-llama, and gen.nvim.
---@module "lazy"
---@type LazySpec
return {
    {
        "yetone/avante.nvim",
        event = "VeryLazy",
        build = "make",
        dependencies = {
            "stevearc/dressing.nvim",
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
            --- The below dependencies are optional,
            "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
            {
                -- support for image pasting
                "HakonHarnes/img-clip.nvim",
                event = "VeryLazy",
                opts = {
                    -- recommended settings
                    default = {
                        embed_image_as_base64 = false,
                        prompt_for_file_name = false,
                        drag_and_drop = {
                            insert_mode = true,
                        },
                        -- required for Windows users
                        use_absolute_path = true,
                    },
                },
            },
        },
        keys = {
            {
                "<leader>ip",
                function()
                    local paste_image_function = (
                        vim.bo.filetype == "AvanteInput" and require("avante.clipboard") or require("img-clip")
                    ).paste_image

                    return paste_image_function()
                end,
                desc = "clip: paste image",
            },
        },
        opts = {
            provider = "claude",                     -- The provider for the service
            auto_suggestions_provider = "openai",    -- The provider for auto suggestions
            behaviour = {
                auto_suggestions = true,             -- Enable auto suggestions
                support_paste_from_clipboard = true, -- Enable support for pasting from clipboard
            },
            file_selector = {
                provider = "telescope", -- The provider for file selection
            },
        },
        --- Configures the avante.nvim plugin with the provided options.
        --- Sets up key mappings and prefill functions for various AI tasks.
        --- @param opts table: The options to configure avante.nvim
        config = function(_, opts)
            require("avante").setup(opts)

            -- prefil edit window with common scenarios to avoid repeating query and submit immediately
            local prefill_edit_window = function(request)
                require("avante.api").edit()
                local code_bufnr = vim.api.nvim_get_current_buf()
                local code_winid = vim.api.nvim_get_current_win()
                if code_bufnr == nil or code_winid == nil then
                    return
                end
                vim.api.nvim_buf_set_lines(code_bufnr, 0, -1, false, { request })
                -- Optionally set the cursor position to the end of the input
                vim.api.nvim_win_set_cursor(code_winid, { 1, #request + 1 })
                -- Simulate Ctrl+S keypress to submit
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-s>", true, true, true), "v", true)
            end

            -- NOTE: most templates are inspired from ChatGPT.nvim -> chatgpt-actions.json
            local avante_grammar_correction =
            "Correct the text to standard English, but keep any code blocks inside intact."
            local avante_keywords = "Extract the main keywords from the following text"
            local avante_code_readability_analysis = [[
            You must identify any readability issues in the code snippet.
            Some readability issues to consider:
            - Unclear naming
            - Unclear purpose
            - Redundant or obvious comments
            - Lack of comments
            - Long or complex one liners
            - Too much nesting
            - Long variable names
            - Inconsistent naming and code style.
            - Code repetition
            You may identify additional problems. The user submits a small section of code from a larger file.
            Only list lines with readability issues, in the format <line_num>|<issue and proposed solution>
            If there's no issues with code respond with only: <OK>
            ]]
            local avante_optimize_code = "Optimize the following code"
            local avante_summarize = "Summarize the following text"
            local avante_translate = "Translate this into Chinese, but keep any code blocks inside intact"
            local avante_explain_code = "Explain the following code"
            local avante_complete_code = "Complete the following codes written in " .. vim.bo.filetype
            local avante_add_docstring = "Add docstring to the following codes"
            local avante_fix_bugs = "Fix the bugs inside the following codes if any"
            local avante_add_tests = "Implement tests for the following code"

            require("which-key").add({
                { "<leader>a", group = "Avante" },
                {
                    mode = { "n", "v" },
                    {
                        "<leader>ag",
                        function()
                            require("avante.api").ask({ question = avante_grammar_correction })
                        end,
                        desc = "Grammar Correction(ask)",
                    },
                    {
                        "<leader>ak",
                        function()
                            require("avante.api").ask({ question = avante_keywords })
                        end,
                        desc = "Keywords(ask)",
                    },
                    {
                        "<leader>al",
                        function()
                            require("avante.api").ask({ question = avante_code_readability_analysis })
                        end,
                        desc = "Code Readability Analysis(ask)",
                    },
                    {
                        "<leader>ao",
                        function()
                            require("avante.api").ask({ question = avante_optimize_code })
                        end,
                        desc = "Optimize Code(ask)",
                    },
                    {
                        "<leader>am",
                        function()
                            require("avante.api").ask({ question = avante_summarize })
                        end,
                        desc = "Summarize text(ask)",
                    },
                    {
                        "<leader>an",
                        function()
                            require("avante.api").ask({ question = avante_translate })
                        end,
                        desc = "Translate text(ask)",
                    },
                    {
                        "<leader>ax",
                        function()
                            require("avante.api").ask({ question = avante_explain_code })
                        end,
                        desc = "Explain Code(ask)",
                    },
                    {
                        "<leader>ac",
                        function()
                            require("avante.api").ask({ question = avante_complete_code })
                        end,
                        desc = "Complete Code(ask)",
                    },
                    {
                        "<leader>ad",
                        function()
                            require("avante.api").ask({ question = avante_add_docstring })
                        end,
                        desc = "Docstring(ask)",
                    },
                    {
                        "<leader>ab",
                        function()
                            require("avante.api").ask({ question = avante_fix_bugs })
                        end,
                        desc = "Fix Bugs(ask)",
                    },
                    {
                        "<leader>au",
                        function()
                            require("avante.api").ask({ question = avante_add_tests })
                        end,
                        desc = "add tests(ask)",
                    },
                },
            })

            require("which-key").add({
                { "<leader>a", group = "Avante" }, -- NOTE: add for avante.nvim
                {
                    mode = { "v" },
                    {
                        "<leader>aG",
                        function()
                            prefill_edit_window(avante_grammar_correction)
                        end,
                        desc = "Grammar Correction",
                    },
                    {
                        "<leader>aK",
                        function()
                            prefill_edit_window(avante_keywords)
                        end,
                        desc = "Keywords",
                    },
                    {
                        "<leader>aO",
                        function()
                            prefill_edit_window(avante_optimize_code)
                        end,
                        desc = "Optimize Code(edit)",
                    },
                    {
                        "<leader>aC",
                        function()
                            prefill_edit_window(avante_complete_code)
                        end,
                        desc = "Complete Code(edit)",
                    },
                    {
                        "<leader>aD",
                        function()
                            prefill_edit_window(avante_add_docstring)
                        end,
                        desc = "Docstring(edit)",
                    },
                    {
                        "<leader>aB",
                        function()
                            prefill_edit_window(avante_fix_bugs)
                        end,
                        desc = "Fix Bugs(edit)",
                    },
                    {
                        "<leader>aU",
                        function()
                            prefill_edit_window(avante_add_tests)
                        end,
                        desc = "Add Tests(edit)",
                    },
                },
            })
        end,
    },
    {
        "exafunction/codeium.vim",
        cond = true,
        event = "BufEnter",
        --- Configures the nvim-llama plugin with default settings.
        --- Sets up the model and other options for the plugin.
        config = function()
            vim.keymap.set("i", "<a-#>", function() -- Accept completion
                return vim.fn["codeium#Accept"]()
            end, { expr = true })

            vim.keymap.set("i", "<a-,>", function() -- Cycle completions forward
                return vim.fn["codeium#CycleCompletions"](1)
            end, { expr = true })

            vim.keymap.set("i", "<a-.>", function() -- Cycle completions backward
                return vim.fn["codeium#CycleCompletions"](-1)
            end, { expr = true })

            vim.keymap.set("i", "<c-x>", function() -- Clear completion
                return vim.fn["codeium#Clear"]()
            end, { expr = true })
        end,
    },
    {
        "jackMort/ChatGPT.nvim",
        event = "VeryLazy",
        config = function()
            require("chatgpt").setup()
        end,
        dependencies = {
            "MunifTanjim/nui.nvim",
            "nvim-lua/plenary.nvim",
            "folke/trouble.nvim", -- optional
            "nvim-telescope/telescope.nvim"
        }
    },
    {
        "jpmcb/nvim-llama",
        event = "VeryLazy",
        cmd = "Llama",
        enabled = false,
        config = function()
            local defaults = {
                debug = false,
                model = "mistral",
                -- model = "neural-chat",
                -- model = "starling-lm",
                -- model = "llama2",
                -- model = "codellama",
                -- model = "llama2-uncensored",
                -- model = "llama2:13b",
                -- model = "llama2:70b",
                -- model = "orca-mini",
                -- model = "vicuna",
            }
            require("nvim-llama").setup(defaults)
        end,
    },
    {
        "david-kunz/gen.nvim",
        enabled = false,
        opts = {
            model = "mistral",     -- the default model to use.
            -- model = "gemma", -- the default model to use.
            host = "localhost",    -- the host running the ollama service.
            port = "11434",        -- the port on which the ollama service is listening.
            quit_map = "q",        -- set keymap for close the response window
            retry_map = "<c-r>",   -- set keymap to re-send the current prompt
            accept_map = "<c-cr>", -- set keymap to accept the current prompt
            -- init = function(options)
            -- 	require("gen").command =
            -- 		"docker exec -it 6b666b088994549337be2e28f758d772c8a2980f8411ddbcb1c4459132075992 /bin/sh -c eval $(grep ^$(id -un): /etc/passwd | cut -d : -f 7-) nvim-llama ollama run $model $prompt"
            -- 	-- pcall(io.popen, "ollama serve > /dev/null 2>&1 &")
            -- end,

            init = function()
                local gen = require("gen") -- Assuming 'gen' is a module or global variable
                if not gen then
                    print("Error: The required module 'gen' is missing.")
                    return
                end

                gen.command = "docker exec -it nvim-llama ollama run $model $prompt"
                local success, error_msg = pcall(os.execute, "ollama serve > /dev/null 2>&1 &")
                if not success then
                    print("Error: Failed to execute command:", error_msg)
                end
            end,
            -- function to initialize ollama
            command = function(options)
                ---@diagnostic disable-next-line: unused-local
                local body = { model = options.model, stream = true }
                return "curl --silent --no-buffer -x post http://"
                    .. options.host
                    .. ":"
                    .. options.port
                    .. "/api/chat -d $body"
            end,
            -- the command for the ollama service. you can use placeholders $prompt, $model and $body (shellescaped).
            -- this can also be a command string.
            -- the executed command must return a json object with { response, context }
            -- (context property is optional).
            -- list_models = '<omitted lua function>', -- retrieves a list of model names
            display_mode = "float", -- the display mode. can be "float" or "split" or "horizontal-split".
            show_prompt = true,     -- shows the prompt submitted to ollama.
            show_model = true,      -- displays which model you are using at the beginning of your chat session.
            no_auto_close = true,   -- never closes the window automatically.
            debug = false,          -- prints errors and the command which is run.
        },
        config = function()
            vim.keymap.set({ "n", "v" }, "<leader>]", ":Gen<cr>")
        end,
    },
}
