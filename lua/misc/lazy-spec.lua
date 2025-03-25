local snacks_config = require("misc.plugin-configs.snacks")
local qmk_config = require("misc.plugin-configs.qmk")

return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = snacks_config.lazy_opts,
    config = snacks_config.lazy_config,
  },
  {
    "codethread/qmk.nvim",
    command = "QMKFormat",
    ft = "c",
    opts = qmk_config.lazy_opts,
  },
}
