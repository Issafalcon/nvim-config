local heirline_config = require("ui.plugin-config.heirline")

return {
  --- Statusline / Bufferlines
  {
    "rebelot/heirline.nvim",
    event = "UIEnter",
    config = heirline_config.lazy_config,
  },
}
