local mini_icons = require("ui.plugin-config.mini-icons")
local catpuccin_colourscheme = require("ui.plugin-config.catppuccin")

return {
  -- icons
  {
    "echasnovski/mini.icons",
    lazy = true,
    opts = mini_icons.lazy_opts,
    init = mini_icons.lazy_init,
  },

  -- colourscheme
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    opts = catpuccin_colourscheme.lazy_opts,
    config = function()
      vim.cmd.colorscheme("catppuccin")
    end,
  },
  { "shaunsingh/oxocarbon.nvim", lazy = false },
}
