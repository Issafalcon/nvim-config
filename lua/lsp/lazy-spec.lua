local lazydev_config = require("lsp.plugin-config.lazydev")

return {
  {
    "folke/lazydev.nvim",
    ft = "lua",
    cmd = "LazyDev",
    opts = lazydev_config.lazy_opts,
  },
  {
    "neovim/nvim-lspconfig",
    event = "BufReadPre",
    dependencies = {
      "lazydev.nvim",
      "lsp-overloads.nvim",
      "mason.nvim",
      -- LSP Completion sources
      "hrsh7th/cmp-nvim-lsp",
      -- Typescript LSP Enhancements
      "jose-elias-alvarez/nvim-lsp-ts-utils",
    },
  },
}
