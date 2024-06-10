return {
  {
    "rebelot/heirline.nvim",
    event = "UIEnter",
    config = function()
      local heirline = require("heirline")
      local conditions = require("heirline.conditions")
      local utils = require("heirline.utils")
      local colours = require("plugins.heirline-components.colours")

      local vimode_component = require("plugins.heirline-components.mode")
      local workdir_component = require("plugins.heirline-components.workdir")
      local filename_component = require("plugins.heirline-components.filename")
      local git_branch = require("plugins.heirline-components.git-branch")

      local tabline_offet = require("plugins.heirline-components.tabline_offset")
      local bufferline = require("plugins.heirline-components.bufferline")

      heirline.load_colors(colours.setup_colors())

      heirline.setup({
        statusline = {
          vimode_component,
          git_branch,
          workdir_component,
          filename_component,
        },
        winbar = nil,
        tabline = { tabline_offet, bufferline },
        statuscolumn = nil,
        -- opts = { ... }, -- other config parameters, see below
      })

      -- Set up the colors
      local augroup = vim.api.nvim_create_augroup("Heirline", { clear = true })
      vim.api.nvim_create_autocmd("ColorScheme", {
        group = augroup,
        desc = "Refresh heirline colors",
        callback = function()
          utils.on_colorscheme(colours.setup_colors())
        end,
      })
    end,
  },
}
