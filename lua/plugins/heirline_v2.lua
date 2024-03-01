-- Theming
-- https://github.com/rebelot/heirline.nvim/blob/master/cookbook.md#theming
local function setup_colors() return require("catppuccin.palettes").get_palette("mocha") end

return {
  {
    "rebelot/heirline.nvim",
    event = "UIEnter",
    config = function()
      local heirline = require("heirline")
      local conditions = require("heirline.conditions")
      local utils = require("heirline.utils")

      local vimode_component = require("plugins.heirline_components.vi_mode")
      local workdir_component = require("plugins.heirline_components.workdir")
      local filename_component = require("plugins.heirline_components.filename")

      heirline.load_colors(setup_colors())

      heirline.setup({
        statusline = {
          vimode_component,
          workdir_component,
          filename_component,
        },
        winbar = {},
        tabline = {},
        statuscolumn = {},
        -- opts = { ... }, -- other config parameters, see below
      })

      -- Set up the colors
      local augroup = vim.api.nvim_create_augroup("Heirline", { clear = true })
      vim.api.nvim_create_autocmd("ColorScheme", {
        group = augroup,
        desc = "Refresh heirline colors",
        callback = function() utils.on_colorscheme(setup_colors()) end,
      })
    end,
  },
}
