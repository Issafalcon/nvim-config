-- https://github.com/folke/which-key.nvim
require("which-key").setup({
  plugins = {
    spelling = { enabled = true },
    presets = { operators = true },
  },
  win = {
    border = "rounded",
    padding = { 2, 2 },
  },
  disable = { filetypes = { "TelescopePrompt" } },
})
