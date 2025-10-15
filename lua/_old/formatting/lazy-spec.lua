local keymaps = require("keymaps").Lsp
local conform_config = require("formatting.plugin-configs.conform")

return {
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = fignvim.mappings.make_lazy_keymaps({
      keymaps.FormatInjectedLangs,
    }),
    init = conform_config.lazy_init,
    opts = conform_config.lazy_opts,
  },
}
