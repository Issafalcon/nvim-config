local mini_icons = require("ui.plugin-config.mini-icons")
local catpuccin_colourscheme = require("ui.plugin-config.catppuccin")
local yazi_config = require("ui.plugin-config.yazi")
local heirline_config = require("ui.plugin-config.heirline")
local bufferline_config = require("ui.plugin-config.bufferline")

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

  --- file managers
  ---@type LazySpec
  {
    "mikavilpas/yazi.nvim",
    dependencies = { "snacks.nvim" },
    event = "VeryLazy",
    keys = fignvim.mappings.make_lazy_keymaps({
      keymaps.OpenTerminalFileManager,
      keymaps.OpenFileManagerInWorkingDirectory,
      keymaps.ResumeLastFileManagerSession,
    }, true),
    ---@type YaziConfig | {}
    opts = yazi_config.lazy_opts,
    -- 👇 if you use `open_for_directories=true`, this is recommended
    init = yazi_config.lazy_init,
  },

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
}
