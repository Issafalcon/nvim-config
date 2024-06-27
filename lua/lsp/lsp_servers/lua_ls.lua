M = {}
M.opts = {
  settings = {
    Lua = {
      completion = {
        callSnippet = "Replace",
      },
      diagnostics = {
        globals = { "vim" },
      },
      hint = {
        enable = true,
      },
    },
  },
}

return M
