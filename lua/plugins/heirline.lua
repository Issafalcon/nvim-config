return {
  {
    "rebelot/heirline.nvim",
    event = "UIEnter",
    config = function()
      local heirline = require("heirline")
      local utils = require("heirline.utils")
      local conditions = require("heirline.conditions")
      local colours = require("heirline-components.colours")
      local surrounds = require("heirline-components.surrounds")

      local vimode_component = require("heirline-components.mode")
      local workdir_component = require("heirline-components.workdir")
      local git_branch = require("heirline-components.git-branch")
      local diagnostics_component = require("heirline-components.diagnostics-component")
      local tabline_offet = require("heirline-components.tabline_offset")
      local bufferline = require("heirline-components.bufferline")
      local ruler_component = require("heirline-components.ruler-component")
      local scrollbar_component = require("heirline-components.scrollbar-component")
      local lspstatus_component = require("heirline-components.lspstatus-component")
      local lspserver_component = require("heirline-components.lspservers-component")

      local align_component = require("heirline-components.align-component")
      local breadcrumb_component = require("heirline-components.breadcrumb-component")
      local winbars = require("heirline-components.winbar")

      heirline.load_colors(colours.setup_colors())

      heirline.setup({
        ---@diagnostic disable-next-line: missing-fields
        statusline = {
          vimode_component,
          git_branch,
          workdir_component,
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
        winbar = winbars,
        tabline = { tabline_offet, bufferline },
        statuscolumn = nil,
        opts = {
          -- if the callback returns true, the winbar will be disabled for that window
          -- the args parameter corresponds to the table argument passed to autocommand callbacks. :h nvim_lua_create_autocmd()
          disable_winbar_cb = function(args)
            return conditions.buffer_matches({
              buftype = { "nofile", "prompt", "help", "quickfix" },
              filetype = { "^git.*", "fugitive", "Trouble", "dashboard" },
            }, args.buf)
          end,
        },
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
