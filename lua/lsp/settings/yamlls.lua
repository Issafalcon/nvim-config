local opts = {
  settings = {
    yaml = {
      schemas = {
        kubernetes = { "*.yaml", "/*.yaml" },
      },
      schemaStore = {
        enable = true,
      },
    },
  },
}

return opts
