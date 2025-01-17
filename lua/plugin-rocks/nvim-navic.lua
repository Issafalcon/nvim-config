require("nvim-navic").setup({
  lsp = {
    auto_attach = true,
    preference = {
      "roslyn",
      "lua_ls",
      "ts_ls",
    },
  },
  highlight = true,
  click = true,
})
