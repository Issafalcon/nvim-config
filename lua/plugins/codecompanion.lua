vim.pack.add({
  { src = "https://github.com/olimorris/codecompanion.nvim" },
})

require("codecompanion").setup({
  opts = {
    log_level = "DEBUG",
    prompt_library = {
      dotnet_gwt_test_workflow = {
        description = "Generate Given-When-Then style NUnit/Moq tests for .NET code in a target folder.",
        steps = {
          "Given a .NET project folder, create a base test class using Moq and NUnit for shared setup.",
          "For each behavior, create a test class file named 'When<Behavior>IsTested.cs' in the folder.",
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
