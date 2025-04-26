local lint_config = require("linting.plugin-configs.nvim-lint")

return {
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre" },
    opts = lint_config.lazy_opts,
    config = lint_config.lazy_config,
  },
}
