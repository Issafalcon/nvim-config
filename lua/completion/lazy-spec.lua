local keymaps = require("keymaps").Completion
local luasnip_config = require("completion.plugin-config.luasnip")

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

  -- Snippets
  {
    "L3MON4D3/LuaSnip",
    dependencies = {
      "rafamadriz/friendly-snippets",
      "robole/vscode-markdown-snippets",
      "J0rgeSerran0/vscode-csharp-snippets",
      "dsznajder/vscode-es7-javascript-react-snippets",
      "fivethree-team/vscode-svelte-snippets",
      "xabikos/vscode-react",
      "thomanq/math-snippets",
    },
    keys = fignvim.mappings.make_lazy_keymaps({
      keymaps.ExpandSnippetOrJump,
      keymaps.PreviousSnippetPlaceholder,
      keymaps.ToggleNextSnippetChoice,
    }, true),
    event = "InsertEnter",
    config = luasnip_config.lazy_config,
  },
}
