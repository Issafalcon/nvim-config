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

local indent_blankline_spec = {
  "lukas-reineke/indent-blankline.nvim",
  event = "BufReadPre",
  opts = {
    show_end_of_line = true,
    space_char_blankline = " ",
  },
}

local bufferline_spec = {
  "akinsho/bufferline.nvim",
  event = "VeryLazy",
  opts = {
    options = {
      diagnostics = "nvim_lsp",
      offsets = {
        { filetype = "NvimTree", text = "", padding = 1 },
        { filetype = "neo-tree", text = "", padding = 1 },
        { filetype = "Outline", text = "", padding = 1 },
      },
      buffer_close_icon = fignvim.ui.get_icon("BufferClose"),
      modified_icon = fignvim.ui.get_icon("FileModified"),
      close_icon = fignvim.ui.get_icon("NeovimClose"),
      diagnostics_indicator = function(_, _, diag)
        local ret = (diag.error and fignvim.ui.get_icon("DiagnosticError") .. diag.error .. " " or "")
          .. (diag.warning and fignvim.ui.get_icon("DiagnosticWarn") .. diag.warning or "")
        return vim.trim(ret)
      end,
      max_name_length = 14,
      max_prefix_length = 13,
      tab_size = 20,
      separator_style = "thin",
    },
  },
}

local maximizer_keys = {
  { "n", "<leader>m", ":MaximizerToggle!<CR>", { desc = "Toggle maximizer (current window)" } },
}

local maximizer_spec = {
  "szw/vim-maximizer",
  cmd = "MaximizerToggle",
  keys = fignvim.mappings.make_lazy_keymaps(maximizer_keys, true),
}

return fignvim.module.enable_registered_plugins({
  ["notify"] = nvim_notify_spec,
  ["colourschemes"] = colourschemes_spec,
  ["dressing"] = dressing_spec,
  ["colorizer"] = colorizer_spec,
  ["heirline"] = require("modules.ui.heirline"),
  ["indent-blankline"] = indent_blankline_spec,
  ["bufferline"] = bufferline_spec,
  ["maximizer"] = maximizer_spec,
}, "ui")
