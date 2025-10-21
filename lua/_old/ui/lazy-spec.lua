local heirline_config = require("ui.plugin-config.heirline")
local notify_config = require("ui.plugin-config.notify")
local keymaps = require("keymaps").UI

return {
  --- Statusline / Bufferlines
  {
    "rebelot/heirline.nvim",
    event = "UIEnter",
    config = heirline_config.lazy_config,
  },

  {
    "rcarriga/nvim-notify",
    event = "UIEnter",
    keys = fignvim.mappings.make_lazy_keymaps({
      keymaps.DismissNotifications,
    }, true),
    opts = notify_config.lazy_opts,
    config = notify_config.lazy_config,
  },
}
