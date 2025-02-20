--- @type FigNvimPluginConfig
local copilot = require("ai.plugin-config.copilot")

local copilot_keys = {
  {
    "i",
    "<Plug>(vimrc:copilot-dummy-map)",
    'copilot#Accept("")',
    {
      desc = "Copilot dummy accept to workaround fallback issues with nvim-cmp",
      expr = true,
      silent = true,
    },
  },
}

return {
  {
    "github/copilot.vim",
    event = "InsertEnter",
    keys = fignvim.mappings.make_lazy_keymaps(copilot_keys, true),
    init = copilot.lazy_init,
  },
}
