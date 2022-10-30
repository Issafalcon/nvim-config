M = {}

M.plugins = {
  -- Plugin manager
  ["wbthomason/packer.nvim"] = {},

  -- Optimiser
  ["lewis6991/impatient.nvim"] = {},

  -- Lua functions
  ["nvim-lua/plenary.nvim"] = { module = "plenary" },

  -- Notification Enhancer
  ["rcarriga/nvim-notify"] = {
    event = "UIEnter",
    config = function()
      require("plugin-configs.notify")
    end,
  },

  -- Neovim UI Enhancer
  ["stevearc/dressing.nvim"] = {
    event = "UIEnter",
    config = function()
      require("plugin-configs.dressing")
    end,
  },

  -- Icons
  ["kyazdani42/nvim-web-devicons"] = {
    disable = not vim.g.icons_enabled,
    module = "nvim-web-devicons",
    config = function()
      require("plugin-configs.nvim-web-devicons")
    end,
  },
  ["onsails/lspkind.nvim"] = {
    disable = not vim.g.icons_enabled,
    module = "lspkind",
    config = function()
      require("plugin-configs.lspkind")
    end,
  },

  -- Bufferline
  ["akinsho/bufferline.nvim"] = {
    event = "UIEnter",
    config = function()
      require("plugin-configs.bufferline")
    end,
  },

  -- File explorer
  ["nvim-neo-tree/neo-tree.nvim"] = {
    branch = "v2.x",
    module = "neo-tree",
    cmd = "Neotree",
    requires = { { "MunifTanjim/nui.nvim", module = "nui" } },
    setup = function()
      vim.g.neo_tree_remove_legacy_commands = true
    end,
    config = function()
      require("plugin-configs.neo-tree")
    end,
  },

  -- Statusline
  ["rebelot/heirline.nvim"] = {
    config = function()
      require("plugin-configs.heirline")
    end,
  },

  -- Parenthesis highlighting
  ["p00f/nvim-ts-rainbow"] = { after = "nvim-treesitter" },

  -- Autoclose tags
  ["windwp/nvim-ts-autotag"] = { after = "nvim-treesitter" },

  -- Commenting
  ["JoosepAlviste/nvim-ts-context-commentstring"] = { after = "nvim-treesitter" },
  ["numToStr/Comment.nvim"] = {
    module = { "Comment", "Comment.api" },
    keys = { "gc", "gb", "g<", "g>" },
    config = function()
      require("plugin-configs.Comment")
    end,
  },

  -- General editing and formatting
  ["junegunn/vim-easy-align"] = {
    config = function()
      require("plugin-configs.vim-easy-align")
    end,
  },

  -- LSP
  ["neovim/nvim-lspconfig"] = {},
  ["jose-elias-alvarez/null-ls.nvim"] = {
    event = "BufEnter",
    config = function()
      require("plugin-configs.null-ls")
    end,
  },

  -- Diagnostics
  ["folke/trouble.nvim"] = {
    config = function()
      require("plugin-configs.trouble")
    end,
  },
}

return M
