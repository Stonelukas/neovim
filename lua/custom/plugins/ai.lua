return {
    {
        "exafunction/codeium.vim",
        event = "bufenter",
        config = function()
            require("codeium").setup({
                enable_chat = true,
            })

            vim.keymap.set("i", "<a-#>", function()
                return vim.fn["codeium#accept"]()
            end, { expr = true })

            vim.keymap.set("i", "<a-,>", function()
                return vim.fn["codeium#cyclecompletions"](1)
            end, { expr = true })

            vim.keymap.set("i", "<a-.>", function()
                return vim.fn["codeium#cyclecompletions"](-1)
            end, { expr = true })

            vim.keymap.set("i", "<c-x>", function()
                return vim.fn["codeium#clear"]()
            end, { expr = true })
        end,
    },
    {
        "exafunction/codeium.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "hrsh7th/nvim-cmp",
        },
        config = function()
            require("codeium").setup({})
        end,
    },
    {
        "jpmcb/nvim-llama",
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
        opts = {
            -- model = "mistral", -- the default model to use.
            model = "gemma", -- the default model to use.
            host = "localhost", -- the host running the ollama service.
            port = "11434", -- the port on which the ollama service is listening.
            quit_map = "q", -- set keymap for close the response window
            retry_map = "<c-r>", -- set keymap to re-send the current prompt
            -- init = function(options)
            -- 	-- require("gen").command = "docker exec -it nvim-llama ollama run $model $prompt"
            -- 	pcall(io.popen, "ollama serve > /dev/null 2>&1 &")
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
            show_prompt = true, -- shows the prompt submitted to ollama.
            show_model = true, -- displays which model you are using at the beginning of your chat session.
            no_auto_close = true, -- never closes the window automatically.
            debug = false, -- prints errors and the command which is run.
        },
        config = function()
            vim.keymap.set({ "n", "v" }, "<leader>]", ":Gen<cr>")
        end,
    },
    {
        "gerazov/ollama-chat.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "stevearc/dressing.nvim",
            "nvim-telescope/telescope.nvim",
        },
        -- lazy load on command
        cmd = {
            "OllamaQuickChat",
            "OllamaCreateNewChat",
            "OllamaContinueChat",
            "OllamaChat",
            "OllamaChatCode",
            "OllamaModel",
            "OllamaServe",
            "OllamaServeStop",
        },

        keys = {
            {
                "<leader>Ocn",
                "<cmd>OllamaCreateNewChat<cr>",
                desc = "Create Ollama Chat",
                mode = { "n", "x" },
                silent = true,
            },
            {
                "<leader>Occ",
                "<cmd>OllamaContinueChat<cr>",
                desc = "Continue Ollama Chat",
                mode = { "n", "x" },
                silent = true,
            },
            {
                "<leader>Och",
                "<cmd>OllamaChat<cr>",
                desc = "Chat",
                mode = { "n" },
                silent = true,
            },
        },

        opts = {
            chats_folder = vim.fn.stdpath("data"), -- data folder is ~/.local/share/nvim
            -- you can also choose "current" and "tmp"
            quick_chat_file = "ollama-chat.md",
            animate_spinner = true, -- set this to false to disable spinner animation
            model = "mistral:latest",
            model_code = "codellama",
            url = "http://127.0.0.1:11434",
            serve = {
                on_start = false,
                command = "ollama",
                args = { "serve" },
                stop_command = "pkill",
                stop_args = { "-SIGTERM", "ollama" },
            },
        },
    },
    -- {
    -- 	"marco-souza/ollero.nvim",
    -- 	build = ":!go install github.com/marco-souza/omg@latest",
    -- 	dependencies = {
    -- 		"nvim-lua/plenary.nvim",
    -- 		"marco-souza/term.nvim",
    -- 		"nvim-telescope/telescope-ui-select.nvim",
    -- 	},
    -- 	config = true,
    -- },
}
