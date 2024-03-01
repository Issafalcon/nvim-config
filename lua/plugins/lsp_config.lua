return {
  {
    "neovim/nvim-lspconfig",
    event = "BufReadPre",
    dependencies = {
      "folke/neodev.nvim",
      "lsp-overloads.nvim",
      "mason.nvim",
      -- LSP Completion sources
      "hrsh7th/cmp-nvim-lsp",
      -- Typescript LSP Enhancements
      "jose-elias-alvarez/nvim-lsp-ts-utils",
    },
  },
}
