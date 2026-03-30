vim.pack.add({
  { src = "https://github.com/SmiteshP/nvim-navic" },
})

require("nvim-navic").setup({
  highlight = true,
  click = true,
  lsp = {
    auto_attach = true,
    preference = {
      "roslyn",
      "lua_ls",
      "ts_ls",
    },
  },
})
