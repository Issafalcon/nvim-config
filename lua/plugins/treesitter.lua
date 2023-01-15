local treesitter_spec = {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = "BufReadPost",
  opts = {
    ensure_installed = "all", -- one of "all" or a list of languages
    ignore_install = { "haskell, phpdoc", "t32" },
    highlight = {
      enable = true, -- false will disable the whole extension
      disable = { "latex" },
      additional_vim_regex_highlighting = false,
    },
    rainbow = {
      enable = true,
      extended_mode = true,
      max_file_lines = nil,
    },
    indent = { enable = false },
    incremental_selection = { enable = true },
    autotag = { enable = true },
    textobjects = {
      select = {
        enable = true,
        -- Automatically jump forward to textobj, similar to targets.vim
        lookahead = true,
        keymaps = {
          -- You can use the capture groups defined in textobjects.scm
          ["af"] = "@function.outer",
          ["if"] = "@function.inner",
          ["ac"] = "@class.outer",
          ["ic"] = "@class.inner",
        },
      },
      move = {
        enable = true,
        set_jumps = true,
        goto_next_start = {
          ["]m"] = "@function.outer",
          ["]]"] = "@class.outer",
        },
        goto_next_end = {
          ["]M"] = "@function.outer",
          ["]["] = "@class.outer",
        },
        goto_previous_start = {
          ["[m"] = "@function.outer",
          ["[["] = "@class.outer",
        },
        goto_previous_end = {
          ["[M"] = "@function.outer",
          ["[]"] = "@class.outer",
        },
      },
      swap = {
        enable = true,
        swap_next = { ["<leader>xp"] = "@parameter.inner" },
        swap_previous = { ["<leader>xP"] = "@parameter.inner" },
      },
      lsp_interop = {
        enable = true,
        border = "none",
        peek_definition_code = {
          ["<leader>pf"] = "@function.outer",
          ["<leader>pc"] = "@class.outer",
        },
      },
    },
    playground = {
      enable = true,
      disable = {},
      updatetime = 25,
      persist_queries = false,
    },
  },
  dependencies = {
    -- Enable treesitter playground
    "nvim-treesitter/playground",
    -- Easier configuration of TS text objects
    "nvim-treesitter/nvim-treesitter-textobjects",
    -- Auto-close HTML tags in various filetypes
    "windwp/nvim-ts-autotag",
    -- Provide context based commentstring
    "JoosepAlviste/nvim-ts-context-commentstring",
    -- Rainbow parentheses using treesitter (TODO: Find alternative - this is no longer maintained)
    "p00f/nvim-ts-rainbow",
  },
}

local aerial_keys = {
  { "n", "<leader>a", "<cmd>AerialToggle!<CR>", { desc = "Toggle LSP symbol outline panel" } },
}

local aerial_spec = {
  "stevearc/aerial.nvim",
  cmd = { "AerialOpen", "AerialToggle" },
  keys = fignvim.config.make_lazy_keymaps(aerial_keys, true),
  dependencies = {
    "telescope.nvim",
  },
  opts = {
    attach_mode = "window",
    backends = { "lsp", "treesitter", "markdown" },
    close_automatic_events = {},
    highlight_on_hover = true,
    layout = {
      min_width = 28,
    },
    show_guides = true,
    filter_kind = false,
    guides = {
      mid_item = "├ ",
      last_item = "└ ",
      nested_top = "│ ",
      whitespace = "  ",
    },
    keymaps = {
      ["[y"] = "actions.prev",
      ["]y"] = "actions.next",
      ["[Y"] = "actions.prev_up",
      ["]Y"] = "actions.next_up",
      ["{"] = false,
      ["}"] = false,
      ["[["] = false,
      ["]]"] = false,
    },
  },
  config = function(_, opts)
    local aerial = fignvim.plug.load_module_file("aerial")
    local telescope = fignvim.plug.load_module_file("telescope")
    aerial.setup(opts)
    fignvim.fn.conditional_func(telescope.load_extension, pcall(require, "aerial"), "aerial")
  end,
}

return {
  treesitter_spec,
  aerial_spec,
}
