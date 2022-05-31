local opts = {
  settings = {
    cucumber = {
      features = { "**/*.feature" },
      glue = { "**/Steps/*.cs", "**/StepDefinitions/*.cs" },
    },
  },
}

return opts
