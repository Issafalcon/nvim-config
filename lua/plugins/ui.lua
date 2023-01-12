local notify_keys = {
  {
    "n",
    "<leader>un",
    function() require("notify").dismiss({ silent = true, pending = true }) end,
    { desc = "Dismiss all notifications" },
  },
}

-- Colourscheme
local colourschemes_spec = {
  {
    "catppuccin/nvim",
    lazy = false,
    priority = 1000,
    opts = function()
      return {
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
      }
    end,
  },
  { "shaunsingh/oxocarbon.nvim" },
}

-- Better notifications
local nvim_notify_spec = {
  "rcarriga/nvim-notify",
  event = "UIEnter",
  keys = fignvim.config.make_lazy_keymaps(notify_keys),
  dependencies = {
    "telescope.nvim",
  },
  opts = {
    stages = "fade_in_slide_out",
    max_height = function() return math.floor(vim.o.lines * 0.75) end,
    max_width = function() return math.floor(vim.o.columns * 0.75) end,
  },
  config = function(_, opts)
    local notify = fignvim.plug.load_module_file("notify")
    local telescope = fignvim.plug.load_module_file("telescope")
    notify.setup(opts)
    fignvim.fn.conditional_func(telescope.load_extension, pcall(require, "notify"), "notify")
  end,
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

-- LSP winbar / statusbar symbol breadcrumbs
local navic_spec = {
  "SmiteshP/nvim-navic",
  init = function()
    vim.g.navic_silence = true
    require("lazyvim.util").on_attach(function(client, buffer)
      if client.server_capabilities.documentSymbolProvider then require("nvim-navic").attach(client, buffer) end
    end)
  end,
  opts = { separator = " ", highlight = true, depth_limit = 5 },
}

local indent_blankline_spec = {
  "lukas-reineke/indent-blankline.nvim",
  event = "BufReadPre",
  opts = {
    show_end_of_line = true,
    space_char_blankline = " ",
  },
}

return {
  colourschemes_spec,
  nvim_notify_spec,
  dressing_spec,
  colorizer_spec,
  navic_spec,
  indent_blankline_spec,
}
