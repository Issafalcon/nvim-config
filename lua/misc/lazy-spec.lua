local snacks_config = require("misc.plugin-configs.snacks")

return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = snacks_config.lazy_opts,
    config = snacks_config.lazy_config,
  },
}
