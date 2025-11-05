vim.pack.add({
  { src = "https://github.com/olimorris/codecompanion.nvim" },
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
  },
  opts = {
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
  },
})
