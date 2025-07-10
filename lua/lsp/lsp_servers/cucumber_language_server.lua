M = {}
M.opts = {
  cmd = { "cucumber-language-server", "--stdio" },
  filetypes = { "cucumber", "feature" },
  root_markers = { ".git" },
  settings = {
    cucumber = {
      features = { "**/*.feature" },
      glue = {
        "**/Steps/*.cs",
        "**/StepDefinitions/*.cs",
        "StagingTests/**/*.cs",
        "**/StagingTests/**/*.cs",
        "**/Behaviours/*.cs",
        "**/*.feature.cs",
      },
    },
  },
}

return M
