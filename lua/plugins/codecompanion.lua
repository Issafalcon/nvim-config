vim.pack.add({
  { src = "https://github.com/olimorris/codecompanion.nvim" },
  { src = "https://github.com/ravitemer/codecompanion-history.nvim" },
})

vim.keymap.set({ "n", "v" }, "<leader>cc", "<cmd>CodeCompanionActions<cr>", { noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "<leader>C", "<cmd>CodeCompanionChat Toggle<cr>", { noremap = true, silent = true })
vim.keymap.set("v", "gC", "<cmd>CodeCompanionChat Add<cr>", { noremap = true, silent = true })

-- Expand 'cc' into 'CodeCompanion' in the command line
vim.cmd([[cab cc CodeCompanion]])

require("codecompanion").setup({
  extensions = {
    mcphub = {
      callback = "mcphub.extensions.codecompanion",
      opts = {
        -- MCP Tools
        make_tools = true, -- Make individual tools (@server__tool) and server groups (@server) from MCP servers
        show_server_tools_in_chat = true, -- Show individual tools in chat completion (when make_tools=true)
        add_mcp_prefix_to_tool_names = false, -- Add mcp__ prefix (e.g `@mcp__github`, `@mcp__neovim__list_issues`)
        show_result_in_chat = true, -- Show tool results directly in chat buffer
        format_tool = nil, -- function(tool_name:string, tool: CodeCompanion.Agent.Tool) : string Function to format tool names to show in the chat buffer
        -- MCP Resources
        make_vars = true, -- Convert MCP resources to #variables for prompts
        -- MCP Prompts
        make_slash_commands = true, -- Add MCP prompts as /slash commands
      },
    },
    history = {
      enabled = true,
      opts = {
        -- Keymap to open history from chat buffer (default: gh)
        keymap = "gh",
        -- Keymap to save the current chat manually (when auto_save is disabled)
        save_chat_keymap = "sc",
        -- Save all chats by default (disable to save only manually using 'sc')
        auto_save = true,
        -- Number of days after which chats are automatically deleted (0 to disable)
        expiration_days = 0,
        -- Picker interface (auto resolved to a valid picker)
        picker = "snacks", --- ("telescope", "snacks", "fzf-lua", or "default")
        ---Optional filter function to control which chats are shown when browsing
        chat_filter = nil, -- function(chat_data) return boolean end
        -- Customize picker keymaps (optional)
        picker_keymaps = {
          rename = { n = "r", i = "<M-r>" },
          delete = { n = "d", i = "<M-d>" },
          duplicate = { n = "<C-y>", i = "<C-y>" },
        },
        ---Automatically generate titles for new chats
        auto_generate_title = true,
        title_generation_opts = {
          ---Adapter for generating titles (defaults to current chat adapter)
          adapter = nil, -- "copilot"
          ---Model for generating titles (defaults to current chat model)
          model = nil, -- "gpt-4o"
          ---Number of user prompts after which to refresh the title (0 to disable)
          refresh_every_n_prompts = 0, -- e.g., 3 to refresh after every 3rd user prompt
          ---Maximum number of times to refresh the title (default: 3)
          max_refreshes = 3,
          format_title = function(original_title)
            -- this can be a custom function that applies some custom
            -- formatting to the title.
            return original_title
          end,
        },
        ---On exiting and entering neovim, loads the last chat on opening chat
        continue_last_chat = false,
        ---When chat is cleared with `gx` delete the chat from history
        delete_on_clearing_chat = false,
        ---Directory path to save the chats
        dir_to_save = vim.fn.stdpath("data") .. "/codecompanion-history",
        ---Enable detailed logging for history extension
        enable_logging = false,

        -- Summary system
        summary = {
          -- Keymap to generate summary for current chat (default: "gcs")
          create_summary_keymap = "gcs",
          -- Keymap to browse summaries (default: "gbs")
          browse_summaries_keymap = "gbs",

          generation_opts = {
            adapter = nil, -- defaults to current chat adapter
            model = nil, -- defaults to current chat model
            context_size = 90000, -- max tokens that the model supports
            include_references = true, -- include slash command content
            include_tool_outputs = true, -- include tool execution results
            system_prompt = nil, -- custom system prompt (string or function)
            format_summary = nil, -- custom function to format generated summary e.g to remove <think/> tags from summary
          },
        },

        -- Memory system (requires VectorCode CLI)
        memory = {
          -- Automatically index summaries when they are generated
          auto_create_memories_on_summary_generation = true,
          -- Path to the VectorCode executable
          vectorcode_exe = "vectorcode",
          -- Tool configuration
          tool_opts = {
            -- Default number of memories to retrieve
            default_num = 10,
          },
          -- Enable notifications for indexing progress
          notify = true,
          -- Index all existing memories on startup
          -- (requires VectorCode 0.6.12+ for efficient incremental indexing)
          index_on_startup = false,
        },
      },
    },
  },
  log_level = "DEBUG",
  prompt_library = {
    ["Maths tutor"] = {
      strategy = "chat",
      description = "Chat with your personal maths tutor",
      opts = {
        index = 4,
        ignore_system_prompt = true,
        intro_message = "Welcome to your lesson! How may I help you today? ",
      },
      prompts = {
        {
          role = "system",
          content = [[You are a helpful maths tutor.
You explain concepts, solve problems, and provide step-by-step solutions for maths.
The user has an MPhys in Physics, is knowledgeable in maths but out of practice, and is an experienced programmer.
Relate maths concepts to programming where possible.

When responding, use this structure:
1. Brief explanation of the topic
2. Definition
3. Simple example and a more complex example
4. Programming analogy or Python example
5. Summary of the topic
6. Question to check user understanding

You must:
- Use only H3 headings and above for section separation
- Show your work and explain each step clearly
- Relate maths concepts to programming terms where applicable
- Use inline LaTeX for equations between $ signs (e.g., $y$)
- Use block LaTeX for standalone equations between $$ signs (e.g., $$y$$)
- Format all mathematical explanations and solutions in LaTeX code blocks (triple backticks with 'latex') for direct use in TeX files
- Use Python for coding examples (triple backticks with 'python')
- Make answers concise for easy transfer to Notion and Anki
- End with a flashcard-ready summary or question

If the user requests only part of the structure, respond accordingly.]],
        },
      },
    },
    ["Dotnet Nunit Behavioural Test Writer"] = {
      description = "Generate Given-When-Then style NUnit/Moq tests for .NET code in a target folder.",
      steps = {
        "Given a .NET project folder, create a base test class using Moq and NUnit for shared setup, if it doesn't exist already.",
        "For each behavior, create a test class file named 'When<Behavior>.cs' in the folder.",
        "Each test method is prefixed with 'Then' and uses NUnit's [Test] attribute.",
        "Tests should mock dependencies, set up test data, and assert expected outcomes.",
      },
      input = {
        folder = "The relative path to the .NET code folder to generate tests for.",
      },
      output = {
        files = "NUnit test files in the Given-When-Then style, placed in the specified folder.",
      },
      example = [[
Input:
  folder: src/MyApp/Services

Output:
  /Tests/Services/WebSearchTestBase.cs
  /Tests/Services/WhenWebSearchIsCalled.cs
        ]],
    },
  },
})
