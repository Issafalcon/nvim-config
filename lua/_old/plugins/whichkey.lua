return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      plugins = {
        spelling = { enabled = true },
        presets = { operators = true },
      },
      win = {
        border = "rounded",
        padding = { 2, 2 },
      },
      disable = { filetypes = { "TelescopePrompt" } },
    },
  },
}
