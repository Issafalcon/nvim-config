local opts = {
  settings = {
    cucumber = {
      features = { "**/*.feature" },
      glue = { "**/Steps/*.cs" },
    },
  },
}

return opts
