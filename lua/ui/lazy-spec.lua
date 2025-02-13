local mini_icons = require("ui.plugin-config.mini-icons")

return {
  -- icons
  {
    "echasnovski/mini.icons",
    lazy = true,
    opts = mini_icons.lazy_opts,
    init = mini_icons.lazy_init,
  },
}
