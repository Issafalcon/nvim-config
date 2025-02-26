local keymaps = require("keymaps").Lsp

return {
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = fignvim.mappings.make_lazy_keymaps({
      keymaps.FormatInjectedLangs,
    }),
  },
}
