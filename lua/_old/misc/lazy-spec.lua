local snacks_config = require("misc.plugin-configs.snacks")
local qmk_config = require("misc.plugin-configs.qmk")
local git_mappings = require("keymaps").Git
local jira_config = require("misc.plugin-configs.jira")

return {
  {
    "folke/snacks.nvim",
    keys = fignvim.mappings.make_lazy_keymaps({
      git_mappings.ToggleLazygit,
    }, true),
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

  -- Jira stuff
  -- Jirac seems to be a bit broken at the moment, so disabling it for now
  -- {
  --   "janBorowy/jirac.nvim",
  --   dependencies = {
  --     "MunifTanjim/nui.nvim",
  --     "grapp-dev/nui-components.nvim",
  --     "nvim-lua/plenary.nvim",
  --   },
  --   lazy = false,
  --   config = jira_config.lazy_config,
  -- },
}
