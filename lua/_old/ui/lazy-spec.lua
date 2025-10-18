local mini_icons = require("ui.plugin-config.mini-icons")
local catpuccin_colourscheme = require("ui.plugin-config.catppuccin")
local heirline_config = require("ui.plugin-config.heirline")
local bufferline_config = require("ui.plugin-config.bufferline")
local dressing_config = require("ui.plugin-config.dressing")
local notify_config = require("ui.plugin-config.notify")
local keymaps = require("keymaps").UI

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

  --- Statusline / Bufferlines
  {
    "rebelot/heirline.nvim",
    event = "UIEnter",
    config = heirline_config.lazy_config,
  },

  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    keys = fignvim.mappings.make_lazy_keymaps({
      keymaps.PinBuffer,
      keymaps.DeleteUnpinnedBuffers,
      keymaps.DeleteBuffersLeft,
      keymaps.DeleteBuffersRight,
      keymaps.PrevBuffer,
      keymaps.NextBuffer,
      keymaps.MoveBufNext,
      keymaps.MoveBufPrev,
    }, true),
    opts = bufferline_config.lazy_opts,
    config = bufferline_config.lazy_config,
  },

  {
    "stevearc/dressing.nvim",
    event = "UIEnter",
    init = dressing_config.lazy_init,
    opts = dressing_config.lazy_opts,
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
