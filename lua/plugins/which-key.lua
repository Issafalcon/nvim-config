vim.pack.add({
  { src = "https://github.com/folke/which-key.nvim" },
})

local which_key = require("which-key")

which_key.setup({
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

which_key.add({
  { "<leader>t", group = "Navigation" },
  {
    "<F7>",
    group = "Terminal",
  },
  { "<leader>x", group = "Diagnostics" },
})
