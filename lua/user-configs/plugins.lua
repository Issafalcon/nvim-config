M = {}

M.plugins = {
  -- Plugin manager
  ["wbthomason/packer.nvim"] = {}, -- https://github.com/wbthomason/packer.nvim

  -- Optimiser
  ["lewis6991/impatient.nvim"] = {}, -- https://github.com/lewis6991/impatient.nvim

  -- Lua functions
  ["nvim-lua/plenary.nvim"] = {}, -- https://github.com/nvim-lua/plenary.nvim

  -- Background compilation / script runner
  ["tpope/vim-dispatch"] = {},

  -- Colorschemes
  ["catppuccin/nvim"] = {
    module = "catppuccin",
    config = function()
      require("plugin-configs.catppuccin")
    end,
  },

  -- Notification Enhancer
  ["rcarriga/nvim-notify"] = {
    -- https://github.com/rcarriga/nvim-notify
    event = "UIEnter",
    config = function()
      require("plugin-configs.notify")
    end,
  },

  -- Neovim UI Enhancer
  ["stevearc/dressing.nvim"] = {
    -- https://github.com/stevearc/dressing.nvim
    event = "UIEnter",
    config = function()
      require("plugin-configs.dressing")
    end,
  },

  -- Icons
  ["nvim-tree/nvim-web-devicons"] = {
    -- https://github.com/nvim-tree/nvim-web-devicons
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
    -- https://github.com/akinsho/bufferline.nvim
    event = "UIEnter",
    config = function()
      require("plugin-configs.bufferline")
    end,
  },

  ["s1n7ax/nvim-window-picker"] = {
    tag = "v1.*",
    module = "window-picker",
    config = function()
      require("configs.window-picker")
    end,
  },

  -- File explorer
  ["nvim-neo-tree/neo-tree.nvim"] = {
    -- https://github.com/nvim-neo-tree/neo-tree.nvim/tree/v2.x
    branch = "v2.x",
    requires = { { "MunifTanjim/nui.nvim", module = "nui" } },
    setup = function()
      vim.g.neo_tree_remove_legacy_commands = true
    end,
    config = function()
      require("plugin-configs.neo-tree")
    end,
  },

  -- Fuzzy finding / searching
  ["nvim-telescope/telescope.nvim"] = {
    module = "telescope",
    config = function()
      require("plugin-configs.telescope")
    end,
  },
  ["nvim-telescope/telescope-fzy-native.nvim"] = { after = "telescope.nvim" },
  ["junegunn/fzf"] = { after = "telescope.nvim" },
  ["windwp/nvim-spectre"] = {
    config = function()
      require("plugin-configs.spectre")
    end,
  },

  -- Snippets
  ["rafamadriz/friendly-snippets"] = {
    opt = true,
  },
  ["robole/vscode-markdown-snippets"] = { opt = true },
  ["J0rgeSerran0/vscode-csharp-snippets"] = { opt = true },
  ["dsznajder/vscode-es7-javascript-react-snippets"] = { opt = true },
  ["fivethree-team/vscode-svelte-snippets"] = { opt = true },
  ["xabikos/vscode-react"] = { opt = true },
  ["L3MON4D3/LuaSnip"] = {
    module = "luasnip",
    wants = "friendly-snippets",
    config = function()
      require("plugin-configs.LuaSnip")
    end,
  },

  -- Completion engine and sources
  ["hrsh7th/nvim-cmp"] = {
    config = function()
      require("plugin-configs.nvim-cmp")
    end,
  },
  ["saadparwaiz1/cmp_luasnip"] = {
    after = "nvim-cmp",
  },
  ["hrsh7th/cmp-buffer"] = {
    after = "nvim-cmp",
  },
  ["hrsh7th/cmp-cmdline"] = {
    after = "nvim-cmp",
  },
  ["hrsh7th/cmp-path"] = {
    after = "nvim-cmp",
  },
  ["hrsh7th/cmp-nvim-lsp"] = {
    after = "nvim-cmp",
  },
  ["hrsh7th/cmp-nvim-lua"] = {
    after = "nvim-cmp",
  },
  ["David-Kunz/cmp-npm"] = {
    after = "nvim-cmp",
  },
  ["lukas-reineke/cmp-rg"] = {
    after = "nvim-cmp",
  },

  -- Copilot
  ["github/copilot.vim"] = {
    commit = "1bfbaf5b027ee4d3d3dbc828c8bfaef2c45d132d",
  },

  -- Statusline
  ["rebelot/heirline.nvim"] = {
    config = function()
      require("plugin-configs.heirline")
    end,
  },

  -- Treesitter (syntax highlighting and more)
  ["p00f/nvim-ts-rainbow"] = { after = "nvim-treesitter" },
  ["windwp/nvim-ts-autotag"] = { after = "nvim-treesitter" },
  ["JoosepAlviste/nvim-ts-context-commentstring"] = { after = "nvim-treesitter" },
  ["nvim-treesitter/nvim-treesitter-textobjects"] = { after = "nvim-treesitter" },
  ["nvim-treesitter/playground"] = { after = "nvim-treesitter" },
  ["nvim-treesitter/nvim-treesitter"] = {
    run = function()
      require("nvim-treesitter.install").update({ with_sync = true })
    end,
    event = "BufEnter",
    config = function()
      require("plugin-configs.nvim-treesitter")
    end,
  },

  -- Commenting
  ["numToStr/Comment.nvim"] = {
    module = { "Comment", "Comment.api" },
    keys = { "gc", "gb", "g<", "g>" },
    config = function()
      require("plugin-configs.Comment")
    end,
  },

  -- General editing and formatting
  ["junegunn/vim-easy-align"] = {},
  ["tpope/vim-surround"] = {}, -- https://github.com/tpope/vim-surround
  ["tpope/vim-unimpaired"] = {}, -- https://github.com/tpope/vim-unimpaired
  ["windwp/nvim-autopairs"] = {
    event = "InsertEnter",
    config = function()
      require("plugin-configs.nvim-autopairs")
    end,
  },
  ["editorconfig/editorconfig-vim"] = {},
  ["lukas-reineke/indent-blankline.nvim"] = {
    event = "BufEnter",
    config = function()
      require("plugin-configs.indent-blankline")
    end,
  },

  -- Package management
  ["williamboman/mason.nvim"] = {
    config = function()
      require("plugin-configs.mason")
    end,
  },
  ["williamboman/mason-lspconfig.nvim"] = {
    after = "mason.nvim",
    config = function()
      require("plugin-configs.mason-lspconfig")
    end,
  },
  ["WhoIsSethDaniel/mason-tool-installer.nvim"] = {
    config = function()
      require("plugin-configs.mason-tool-installer")
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
  ["stevearc/aerial.nvim"] = {
    module = "aerial",
    before = "telescope.nvim",
    config = function()
      require("plugin-configs.aerial")
    end,
  },

  -- Diagnostics
  ["folke/trouble.nvim"] = {
    config = function()
      require("plugin-configs.trouble")
    end,
  },

  -- Keybindings / Cheatsheets / Help
  ["Issafalcon/nvim-mapper"] = {
    config = function()
      require("nvim-mapper").setup({})
      if fignvim.plug.is_available("telescope.nvim") then
        require("telescope").load_extension("mapper")
      end
    end,
    after = "telescope.nvim",
  },
  ["sudormrfbin/cheatsheet.nvim"] = {
    config = function()
      require("plugin-configs.cheatsheet")
    end,
  },

  -- Terminal
  ["akinsho/toggleterm.nvim"] = {
    cmd = "ToggleTerm",
    module = { "toggleterm", "toggleterm.terminal" },
    config = function()
      require("plugin-configs.toggleterm")
    end,
  },

  -- Git integrations
  ["sindrets/diffview.nvim"] = {
    after = "plenary.nvim",
    config = function()
      require("plugin-configs.diffview")
    end,
  },
  ["lewis6991/gitsigns.nvim"] = {
    config = function()
      require("plugin-configs.gitsigns")
    end,
  },
  ["rhysd/git-messenger.vim"] = {},
  ["tpope/vim-fugitive"] = {},

  -- Note taking
  ["lervag/vimtex"] = {},

  -- Testing
  ["nvim-neotest/neotest"] = {
    config = function()
      require("plugin-configs.neotest")
    end,
    requires = {
      "vim-test/vim-test",
      "nvim-lua/plenary.nvim",
      "nvim-neotest/neotest-python",
      "nvim-neotest/neotest-plenary",
      "nvim-neotest/neotest-vim-test",
      "Issafalcon/neotest-dotnet",
      "haydenmeade/neotest-jest",
      "antoinemadec/FixCursorHold.nvim",
    },
  },
}

return M
