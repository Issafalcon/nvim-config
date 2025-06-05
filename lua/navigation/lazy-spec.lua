local navigation_keymaps = require("keymaps").Navigation
local aerial_config = require("navigation.plugin-configs.aerial")

return {
  {
    "stevearc/aerial.nvim",
    cmd = { "AerialOpen", "AerialToggle" },
    keys = fignvim.mappings.make_lazy_keymaps({ navigation_keymaps.ToggleLspOutline }, true),
    opts = aerial_config.lazy_opts,
    config = aerial_config.lazy_config,
  },
}
