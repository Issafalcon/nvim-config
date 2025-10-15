vim.pack.add({
  { src = "https://github.com/neovim/nvim-lspconfig" },
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "lua",
  callback = function()
    vim.lsp.enable("lua_ls")
  end,
  desc = "Start Python LSP",
})
