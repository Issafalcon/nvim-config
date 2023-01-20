local notify_keys = {
  {
    "n",
    "<leader>un",
    function() require("notify").dismiss({ silent = true, pending = true }) end,
    { desc = "Dismiss all notifications" },
  },
}

local nvim_notify_spec = {
  "rcarriga/nvim-notify",
  event = "UIEnter",
  keys = fignvim.mappings.make_lazy_keymaps(notify_keys, true),
  opts = {
    stages = "fade_in_slide_out",
    max_height = function() return math.floor(vim.o.lines * 0.75) end,
    max_width = function() return math.floor(vim.o.columns * 0.75) end,
  },
  config = function(_, opts) vim.notify = require("notify") end,
}

-- Colourschemes
local colourschemes_spec = {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    opts = {
      flavour = "mocha",
      transparent_background = false,
      term_colors = true,
      integrations = {
        telescope = true,
        aerial = true,
        gitsigns = true,
        cmp = true,
        nvimtree = true,
        mason = true,
      },
      dim_inactive = {
        enabled = true,
        shade = "dark",
        percentage = 0.10,
      },
    },
    config = function() vim.cmd.colorscheme("catppuccin") end,
  },
  { "shaunsingh/oxocarbon.nvim", lazy = false },
}

-- UI Component Upgrades
local dressing_spec = {
  "stevearc/dressing.nvim",
  event = "UIEnter",
  init = function()
    ---@diagnostic disable-next-line: duplicate-set-field
    vim.ui.select = function(...)
      require("lazy").load({ plugins = { "dressing.nvim" } })
      return vim.ui.select(...)
    end
    ---@diagnostic disable-next-line: duplicate-set-field
    vim.ui.input = function(...)
      require("lazy").load({ plugins = { "dressing.nvim" } })
      return vim.ui.input(...)
    end
  end,
  opts = {
    input = {
      default_prompt = "➤ ",
      win_options = { winhighlight = "Normal:Normal,NormalNC:Normal" },
    },
    select = {
      backend = { "telescope", "builtin" },
      builtin = { win_options = { winhighlight = "Normal:Normal,NormalNC:Normal" } },
    },
  },
}

-- Add colour to colour names
local colorizer_spec = {
  "NvChad/nvim-colorizer.lua",
  event = { "BufRead", "BufWinEnter", "BufNewFile" },
  opts = {
    filetypes = {
      css = {
        css = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
        css_fn = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn
        rgb_fn = true, -- CSS rgb() and rgba() functions
        hsl_fn = true, -- CSS hsl() and hsla() functions
        mode = "background",
        names = true,
      },
      ---@diagnostic disable-next-line: undefined-global
      sass = { enable = true, parsers = { css } }, -- Enable sass colors
      "javascript",
      "javascriptreact",
      "typescript",
      "typescriptreact",
      "html",
      "lua",
    },
    user_default_options = {
      mode = "background",
      names = false,
    },
  },
}

return fignvim.module.enable_registered_plugins({
  ["notify"] = nvim_notify_spec,
  ["colourschemes"] = colourschemes_spec,
  ["dressing"] = dressing_spec,
  ["colorizer"] = colorizer_spec,
  ["heirline"] = require("modules.ui.heirline"),
}, "ui")
