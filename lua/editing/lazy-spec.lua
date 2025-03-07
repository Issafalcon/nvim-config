local keymaps = require("keymaps").Editing
local grugfar_config = require("editing.plugin-config.grug-far")

return {
  {
    "MagicDuck/grug-far.nvim",
    opts = grugfar_config.lazy_opts,
    cmd = "GrugFar",
    keys = fignvim.mappings.make_lazy_keymaps({
      keymaps.SearchAndReplace
    }, true),
  },
}
