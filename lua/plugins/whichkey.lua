return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      plugins = {
        spelling = { enabled = true },
        presets = { operators = true },
      },
      window = {
        border = "rounded",
        padding = { 2, 2, 2, 2 },
      },
      disable = { filetypes = { "TelescopePrompt" } },
    },
  },
}
