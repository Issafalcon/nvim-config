local keymaps = require("keymaps").Testing
local neotest_config = require("testing.plugin-configs.neotest")

return {
  "nvim-neotest/neotest",
  event = "VeryLazy",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-neotest/nvim-nio",
    "nvim-neotest/neotest-python",
    "nvim-neotest/neotest-plenary",
    "nvim-neotest/neotest-jest",
    "Issafalcon/neotest-dotnet",
    -- { dir = "~/repos/neotest-dotnet" },
  },
  keys = fignvim.mappings.make_lazy_keymaps(keymaps, true),
  config = neotest_config.lazy_config,
}
