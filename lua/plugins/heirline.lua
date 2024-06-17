return {
  {
    "rebelot/heirline.nvim",
    event = "UIEnter",
    config = function()
      local heirline = require("heirline")
      local utils = require("heirline.utils")
      local colours = require("plugins.heirline-components.colours")
      local surrounds = require("plugins.heirline-components.surrounds")

      local vimode_component = require("plugins.heirline-components.mode")
      local workdir_component = require("plugins.heirline-components.workdir")
      local filename_component = require("plugins.heirline-components.filename")
      local git_branch = require("plugins.heirline-components.git-branch")
      local diagnostics_component =
        require("plugins.heirline-components.diagnostics-component")
      local tabline_offet = require("plugins.heirline-components.tabline_offset")
      local bufferline = require("plugins.heirline-components.bufferline")
      local ruler_component = require("plugins.heirline-components.ruler-component")
      local scrollbar_component =
        require("plugins.heirline-components.scrollbar-component")
      local lspstatus_component =
        require("plugins.heirline-components.lspstatus-component")
      local lspserver_component =
        require("plugins.heirline-components.lspservers-component")

      local align_component = require("plugins.heirline-components.align-component")
      local breadcrumb_component =
        require("plugins.heirline-components.breadcrumb-component")

      heirline.load_colors(colours.setup_colors())

      heirline.setup({
        ---@diagnostic disable-next-line: missing-fields
        statusline = {
          vimode_component,
          git_branch,
          workdir_component,
          filename_component,
          align_component,
          breadcrumb_component,
          align_component,
          diagnostics_component,
          surrounds.RightSlantStart,
          lspstatus_component,
          lspserver_component,
          surrounds.RightSlantEnd,
          ruler_component,
          scrollbar_component,
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
