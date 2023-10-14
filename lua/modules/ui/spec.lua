local notify_keys = {
  {
    "n",
    "<leader>nd",
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
    background_colour = "#000000",
    max_height = function() return math.floor(vim.o.lines * 0.75) end,
    max_width = function() return math.floor(vim.o.columns * 0.75) end,
  },
  config = function(_, opts)
    local notify_plugin = require("notify")
    notify_plugin.setup(opts)
    vim.notify = notify_plugin
  end,
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
  event = "VeryLazy",
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
  main = "ibl",
  opts = {
    indent = {
      char = "│",
    },
    scope = {
      enabled = true,
      show_start = false,
      show_end = false,
      injected_languages = false,
      highlight = { "Function", "Label" },
      priority = 500,
    },
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

local transparent_spec = {
  "xiyaowong/transparent.nvim",
  lazy = false,
  opts = {
    groups = { -- table: default groups
      "Normal",
      "NormalNC",
      "Comment",
      "Constant",
      "Special",
      "Identifier",
      "Statement",
      "PreProc",
      "Type",
      "Underlined",
      "Todo",
      "String",
      "Function",
      "Conditional",
      "Repeat",
      "Operator",
      "Structure",
      "LineNr",
      "NonText",
      "SignColumn",
      "CursorLineNr",
      "EndOfBuffer",
    },
    extra_groups = {}, -- table: additional groups that should be cleared
    exclude_groups = {}, -- table: groups you don't want to clear
  },
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
  ["transparent"] = transparent_spec,
}, "ui")
