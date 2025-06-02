-- https://github.com/rebelot/heirline.nvim

---@type FigNvimPluginConfig
local M = {}

M.lazy_config = function()
  local heirline = require("heirline")
  local utils = require("heirline.utils")
  local conditions = require("heirline.conditions")
  local colours = require("ui.heirline-components.colours")
  local surrounds = require("ui.heirline-components.surrounds")
  local space_component = require("ui.heirline-components.space-component")

  local vimode_component = require("ui.heirline-components.mode-component")
  local git_component = require("ui.heirline-components.git-component")

  local workdir_component = require("ui.heirline-components.workdir-component")
  local diagnostics_component = require("ui.heirline-components.diagnostics-component")
  local ruler_component = require("ui.heirline-components.ruler-component")
  local scrollbar_component = require("ui.heirline-components.scrollbar-component")
  local lspstatus_component = require("ui.heirline-components.lspstatus-component")
  local lspserver_component = require("ui.heirline-components.lspservers-component")

  local align_component = require("ui.heirline-components.align-component")
  local winbars = require("ui.heirline-components.winbar")

  heirline.load_colors(colours.setup_colors())

  heirline.setup({
    ---@diagnostic disable-next-line: missing-fields
    statusline = {
      vimode_component,
      {
        condition = conditions.is_git_repo,
        surrounds.LeftSlantStart,
        git_component,
        surrounds.LeftSlantEnd,
      },

      surrounds.LeftSlantStart,
      workdir_component,
      surrounds.LeftSlantEnd,

      align_component,

      {
        condition = conditions.has_diagnostics,
        surrounds.RightSlantStart,
        diagnostics_component,
        surrounds.RightSlantEnd,
      },

      surrounds.RightSlantStart,
      space_component,
      lspstatus_component,
      lspserver_component,
      surrounds.RightSlantEnd,

      ruler_component,
      scrollbar_component,
    },
    winbar = winbars,
    tabline = nil,
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
end

return M
