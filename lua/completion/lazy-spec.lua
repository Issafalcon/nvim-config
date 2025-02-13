return {
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lsp",
      "David-Kunz/cmp-npm",
      "lukas-reineke/cmp-rg",
      "PasiBergman/cmp-nuget",
    },
    config = function()
      require("completion.plugin-config.nvim-cmp").setup()
    end,
  },
}
