M = {}

M.plugins = {
  -- Optimiser
  ["lewis6991/impatient.nvim"] = {}, -- https://github.com/lewis6991/impatient.nvim

  -- Lua functions
  ["nvim-lua/plenary.nvim"] = {
    lazy = false,
  }, -- https://github.com/nvim-lua/plenary.nvim

  -- Background compilation / script runnerplugins
  ["tpope/vim-dispatch"] = {},

  -- Colorschemes
  ["catppuccin/nvim"] = {
    lazy = false,
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

  -- Neovim UI Enhancements
  ["stevearc/dressing.nvim"] = {
    -- https://github.com/stevearc/dressing.nvim
    event = "UIEnter",
    config = function()
      require("plugin-configs.dressing")
    end,
  },
  ["NvChad/nvim-colorizer.lua"] = {
    opt = true,
    init = function()
      table.insert(fignvim.plug.file_plugins, "nvim-colorizer.lua")
    end,
    config = function()
      require("plugin-configs.colorizer")
    end,
  },

  -- PlantUML
  ["aklt/plantuml-syntax"] = {
    opt = true,
    init = function()
      table.insert(fignvim.plug.file_plugins, "plantuml-syntax")
    end,
  },
  ["weirongxu/plantuml-previewer.vim"] = {
    opt = true,
    dependencies = {
      "tyru/open-browser.vim",
    },
    init = function()
      table.insert(fignvim.plug.file_plugins, "plantuml-previewer.vim")
    end,
  },

  -- Icons
  ["nvim-tree/nvim-web-devicons"] = {
    enabled = vim.g.icons_enabled,
    config = function()
      require("plugin-configs.nvim-web-devicons")
    end,
  },
  ["onsails/lspkind.nvim"] = {
    enabled = vim.g.icons_enabled,
    config = function()
      require("plugin-configs.lspkind")
    end,
  },

  -- Windows, Buffers and Tabs
  ["szw/vim-maximizer"] = {
    cmd = "MaximizerToggle",
  },
  ["akinsho/bufferline.nvim"] = {
    -- https://github.com/akinsho/bufferline.nvim
    event = "UIEnter",
    config = function()
      require("plugin-configs.bufferline")
    end,
  },
  ["s1n7ax/nvim-window-picker"] = {
    version = "v1.*",
    config = function()
      require("plugin-configs.window-picker")
    end,
  },

  -- Navigation
  ["nvim-neo-tree/neo-tree.nvim"] = {
    -- https://github.com/nvim-neo-tree/neo-tree.nvim/tree/v2.x
    branch = "v2.x",
    dependencies = { { "MunifTanjim/nui.nvim" } },
    init = function()
      vim.g.neo_tree_remove_legacy_commands = true
    end,
    config = function()
      require("plugin-configs.neo-tree")
    end,
  },
  ["kevinhwang91/rnvimr"] = {
    cmd = "RnvimrToggle",
    cond = function()
      return vim.fn.executable("ranger") == 1
    end,
  },
  ["ggandor/leap.nvim"] = {
    config = function()
      require("plugin-configs.leap")
    end,
  },
  ["mbbill/undotree"] = {
    cmd = "UndotreeToggle",
  },

  -- Quickfix / Location List
  ["kevinhwang91/nvim-bqf"] = {},

  -- Fuzzy finding / searching
  ["nvim-telescope/telescope.nvim"] = {
    cmd = "Telescope",
    config = function()
      require("plugin-configs.telescope")
    end,
  },
  ["nvim-telescope/telescope-fzy-native.nvim"] = { dependencies = { "telescope.nvim" } },
  ["nvim-telescope/telescope-fzf-native.nvim"] = { dependencies = { "telescope.nvim" } },
  ["junegunn/fzf"] = { dependencies = { "telescope.nvim" } },
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
    dependencies = { "friendly-snippets" },
    config = function()
      require("plugin-configs.LuaSnip")
    end,
  },

  -- Markdown editing
  ["iamcco/markdown-preview.nvim"] = {
    run = "cd app && npm install",
  },

  -- .NET / C# development specific
  -- ["~/repos/neo-sharper.nvim"] = {
  --   config = function()
  --     require("neo-sharper").setup()
  --   end,
  -- },

  ["Hoffs/omnisharp-extended-lsp.nvim"] = {},

  -- Completion engine and sources
  ["hrsh7th/nvim-cmp"] = {
    config = function()
      require("plugin-configs.nvim-cmp")
    end,
    dependencies = {
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lua",
      "David-Kunz/cmp-npm",
      "lukas-reineke/cmp-rg",
    },
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
  ["nvim-treesitter/nvim-treesitter"] = {
    build = function()
      require("nvim-treesitter.install").update({ with_sync = true })
    end,
    event = "BufEnter",
    config = function()
      require("plugin-configs.nvim-treesitter")
    end,
    dependencies = {
      "p00f/nvim-ts-rainbow",
      "windwp/nvim-ts-autotag",
      "JoosepAlviste/nvim-ts-context-commentstring",
      "nvim-treesitter/nvim-treesitter-textobjects",
      "nvim-treesitter/playground",
    },
  },

  -- Commenting
  ["numToStr/Comment.nvim"] = {
    keys = { { "gc", nil, { "n", "v" } }, { "gb", nil, { "n", "v" } }, "g<", "g>" },
    config = function()
      require("plugin-configs.Comment")
    end,
  },
  ["danymat/neogen"] = {
    config = function()
      require("plugin-configs.neogen")
    end,
  },

  -- General editing and formatting
  ["junegunn/vim-easy-align"] = {},
  ["AckslD/nvim-neoclip.lua"] = {
    config = function()
      require("plugin-configs.nvim-neoclip")
    end,
  },
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
  ["ziontee113/icon-picker.nvim"] = {
    config = function()
      require("plugin-configs.icon-picker")
    end,
  },
  ["svermeulen/vim-cutlass"] = {},
  ["svermeulen/vim-subversive"] = {},
  ["tpope/vim-abolish"] = {},
  ["ThePrimeagen/refactoring.nvim"] = {},

  -- Package management
  ["williamboman/mason.nvim"] = {
    config = function()
      require("plugin-configs.mason")
    end,
    dependencies = {
      {
        "williamboman/mason-lspconfig.nvim",
        config = function()
          require("plugin-configs.mason-lspconfig")
        end,
      },
      {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        config = function()
          require("plugin-configs.mason-tool-installer")
        end,
      },
    },
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
    dependencies = { "telescope.nvim" },
    config = function()
      require("plugin-configs.aerial")
    end,
  },
  ["jose-elias-alvarez/nvim-lsp-ts-utils"] = {},
  ["Issafalcon/lsp-overloads.nvim"] = {},
  ["b0o/schemastore.nvim"] = {},

  -- Diagnostics
  ["folke/trouble.nvim"] = {
    config = function()
      require("plugin-configs.trouble")
    end,
  },

  -- Keybindings / Cheatsheets / Help
  ["mrjones2014/legendary.nvim"] = {},
  ["folke/which-key.nvim"] = {
    config = function()
      require("plugin-configs.which-key")
    end,
  },
  ["sudormrfbin/cheatsheet.nvim"] = {
    config = function()
      require("plugin-configs.cheatsheet")
    end,
  },

  -- Terminal
  ["akinsho/toggleterm.nvim"] = {
    cmd = "ToggleTerm",
    config = function()
      require("plugin-configs.toggleterm")
    end,
  },

  -- Git integrations
  ["sindrets/diffview.nvim"] = {
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
    dependencies = {
      "vim-test/vim-test",
      "nvim-neotest/neotest-python",
      "nvim-neotest/neotest-plenary",
      "nvim-neotest/neotest-vim-test",
      "Issafalcon/neotest-dotnet",
      "haydenmeade/neotest-jest",
      "antoinemadec/FixCursorHold.nvim",
    },
  },

  -- Debugging
  ["mfussenegger/nvim-dap"] = {
    config = function()
      require("plugin-configs.nvim-dap")
    end,
  },
  ["rcarriga/nvim-dap-ui"] = {
    dependencies = "mfussenegger/nvim-dap",
    config = function()
      require("plugin-configs.nvim-dap-ui")
    end,
  },
  ["theHamsta/nvim-dap-virtual-text"] = {
    dependencies = "mfussenegger/nvim-dap",
    config = function()
      require("plugin-configs.nvim-dap-virtual-text")
    end,
  },
  ["michaelb/sniprun"] = {
    run = "bash install.sh",
    config = function()
      require("plugin-configs.sniprun")
    end,
  },
  ["mxsdev/nvim-dap-vscode-js"] = {
    dependencies = "mfussenegger/nvim-dap",
    config = function()
      require("plugin-configs.nvim-dap-vscode-js")
    end,
  },
  ["jbyuki/one-small-step-for-vimkind"] = {},

  -- Session management
  ["rmagatti/auto-session"] = {
    config = function()
      require("plugin-configs.auto-session")
    end,
    dependencies = {
      {
        "rmagatti/session-lens",
        config = function()
          require("plugin-configs.session-lens")
        end,
      },
    },
  },

  -- Terraform
  ["hashivim/vim-terraform"] = {},
  ["juliosueiras/vim-terraform-completion"] = {},

  -- Plugin Development
  ["folke/neodev.nvim"] = {},
  ["rafcamlet/nvim-luapad"] = {},
}

return M
