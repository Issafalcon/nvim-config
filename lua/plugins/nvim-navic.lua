return {
  "SmiteshP/nvim-navic",
  dependencies = {
    "neovim/nvim-lspconfig",
  },
  opts = {
    lsp = {
      auto_attach = true,
      preference = {
        "roslyn",
        "lua_ls",
        "tsserver",
      },
    },
  },
  highlight = true,
  click = true,
}
