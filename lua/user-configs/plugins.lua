M = {}

M.plugins = {
  -- Plugin manager
  ["wbthomason/packer.nvim"] = {}, -- https://github.com/wbthomason/packer.nvim

  -- Optimiser
  ["lewis6991/impatient.nvim"] = {}, -- https://github.com/lewis6991/impatient.nvim

  -- Lua functions
  ["nvim-lua/plenary.nvim"] = {}, -- https://github.com/nvim-lua/plenary.nvim

  -- Background compilation / script runnerplugins
  ["tpope/vim-dispatch"] = {},

  -- Colorschemes
  -- DONE
  ["catppuccin/nvim"] = {
    module = "catppuccin",
    config = function() require("plugin-configs.catppuccin") end,
  },

  -- Notification Enhancer
  -- DONE
  ["rcarriga/nvim-notify"] = {
    -- https://github.com/rcarriga/nvim-notify
    event = "UIEnter",
    config = function() require("plugin-configs.notify") end,
  },

  -- Neovim UI Enhancements
  -- DONE
  ["stevearc/dressing.nvim"] = {
    -- https://github.com/stevearc/dressing.nvim
    event = "UIEnter",
    config = function() require("plugin-configs.dressing") end,
  },

  -- DONE
  ["NvChad/nvim-colorizer.lua"] = {
    opt = true,
    setup = function() table.insert(fignvim.plug.file_plugins, "nvim-colorizer.lua") end,
    config = function() require("plugin-configs.colorizer") end,
  },

  -- PlantUML
  ["aklt/plantuml-syntax"] = {
    opt = true,
    setup = function() table.insert(fignvim.plug.file_plugins, "plantuml-syntax") end,
  },
  ["weirongxu/plantuml-previewer.vim"] = {
    opt = true,
    requires = {
      "tyru/open-browser.vim",
    },
    setup = function() table.insert(fignvim.plug.file_plugins, "plantuml-previewer.vim") end,
  },

  -- Icons
  ["nvim-tree/nvim-web-devicons"] = {
    -- https://github.com/nvim-tree/nvim-web-devicons
    disable = not vim.g.icons_enabled,
    module = "nvim-web-devicons",
    config = function() require("plugin-configs.nvim-web-devicons") end,
  },
  ["onsails/lspkind.nvim"] = {
    disable = not vim.g.icons_enabled,
    module = "lspkind",
    config = function() require("plugin-configs.lspkind") end,
  },

  -- Windows, Buffers and Tabs
  ["szw/vim-maximizer"] = {
    cmd = "MaximizerToggle",
  },
  ["akinsho/bufferline.nvim"] = {
    -- https://github.com/akinsho/bufferline.nvim
    event = "UIEnter",
    config = function() require("plugin-configs.bufferline") end,
  },
  ["s1n7ax/nvim-window-picker"] = {
    tag = "v1.*",
    module = "window-picker",
    config = function() require("configs.window-picker") end,
  },

  -- Navigation
  ["nvim-neo-tree/neo-tree.nvim"] = {
    -- https://github.com/nvim-neo-tree/neo-tree.nvim/tree/v2.x
    branch = "v2.x",
    requires = { { "MunifTanjim/nui.nvim", module = "nui" } },
    setup = function() vim.g.neo_tree_remove_legacy_commands = true end,
    config = function() require("plugin-configs.neo-tree") end,
  },
  ["kevinhwang91/rnvimr"] = {
    cmd = "RnvimrToggle",
    cond = function() return vim.fn.executable("ranger") == 1 end,
  },
  ["ggandor/leap.nvim"] = {
    config = function() require("plugin-configs.leap") end,
  },
  ["mbbill/undotree"] = {
    cmd = "UndotreeToggle",
  },

  -- Quickfix / Location List
  ["kevinhwang91/nvim-bqf"] = {},

  -- Fuzzy finding / searching
  -- DONE
  ["nvim-telescope/telescope.nvim"] = {
    module = "telescope",
    config = function() require("plugin-configs.telescope") end,
  },
  -- DONE
  ["nvim-telescope/telescope-fzy-native.nvim"] = { before = "telescope.nvim" },
  -- DONE
  ["nvim-telescope/telescope-fzf-native.nvim"] = { before = "telescope.nvim" },
  --DONE
  ["junegunn/fzf"] = { before = "telescope.nvim" },
  ["windwp/nvim-spectre"] = {
    config = function() require("plugin-configs.spectre") end,
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
    config = function() require("plugin-configs.LuaSnip") end,
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
    config = function() require("plugin-configs.nvim-cmp") end,
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
    config = function() require("plugin-configs.heirline") end,
  },

  -- Treesitter (syntax highlighting and more)
  ["p00f/nvim-ts-rainbow"] = { after = "nvim-treesitter" },
  ["windwp/nvim-ts-autotag"] = { after = "nvim-treesitter" },
  ["JoosepAlviste/nvim-ts-context-commentstring"] = { after = "nvim-treesitter" },
  ["nvim-treesitter/nvim-treesitter-textobjects"] = { after = "nvim-treesitter" },
  ["nvim-treesitter/playground"] = { after = "nvim-treesitter" },
  ["nvim-treesitter/nvim-treesitter"] = {
    run = function() require("nvim-treesitter.install").update({ with_sync = true }) end,
    event = "BufEnter",
    config = function() require("plugin-configs.nvim-treesitter") end,
  },

  -- Commenting
  ["numToStr/Comment.nvim"] = {
    module = { "Comment", "Comment.api" },
    keys = { "gc", "gb", "g<", "g>" },
    config = function() require("plugin-configs.Comment") end,
  },
  ["danymat/neogen"] = {
    module = "neogen",
    config = function() require("plugin-configs.neogen") end,
  },

  -- General editing and formatting
  ["junegunn/vim-easy-align"] = {},
  ["AckslD/nvim-neoclip.lua"] = {
    config = function() require("plugin-configs.nvim-neoclip") end,
  },
  ["tpope/vim-surround"] = {}, -- https://github.com/tpope/vim-surround
  ["tpope/vim-unimpaired"] = {}, -- https://github.com/tpope/vim-unimpaired
  -- DONE
  ["windwp/nvim-autopairs"] = {
    event = "InsertEnter",
    config = function() require("plugin-configs.nvim-autopairs") end,
  },
  ["editorconfig/editorconfig-vim"] = {},
  -- DONE
  ["lukas-reineke/indent-blankline.nvim"] = {
    event = "BufEnter",
    config = function() require("plugin-configs.indent-blankline") end,
  },
  ["ziontee113/icon-picker.nvim"] = {
    config = function() require("plugin-configs.icon-picker") end,
  },
  -- DONE
  ["svermeulen/vim-cutlass"] = {},
  ["svermeulen/vim-subversive"] = {},
  ["tpope/vim-abolish"] = {},
  ["ThePrimeagen/refactoring.nvim"] = {},

  -- Package management
  ["williamboman/mason.nvim"] = {
    config = function() require("plugin-configs.mason") end,
  },
  ["williamboman/mason-lspconfig.nvim"] = {
    after = "mason.nvim",
    config = function() require("plugin-configs.mason-lspconfig") end,
  },
  ["WhoIsSethDaniel/mason-tool-installer.nvim"] = {
    config = function() require("plugin-configs.mason-tool-installer") end,
  },

  -- LSP
  ["neovim/nvim-lspconfig"] = {},
  ["jose-elias-alvarez/null-ls.nvim"] = {
    event = "BufEnter",
    config = function() require("plugin-configs.null-ls") end,
  },
  ["stevearc/aerial.nvim"] = {
    module = "aerial",
    before = "telescope.nvim",
    config = function() require("plugin-configs.aerial") end,
  },
  ["jose-elias-alvarez/nvim-lsp-ts-utils"] = {},
  ["Issafalcon/lsp-overloads.nvim"] = {},
  ["b0o/schemastore.nvim"] = {},

  -- Diagnostics
  ["folke/trouble.nvim"] = {
    config = function() require("plugin-configs.trouble") end,
  },

  -- Keybindings / Cheatsheets / Help
  ["mrjones2014/legendary.nvim"] = {},
  ["folke/which-key.nvim"] = {
    module = "which-key",
    config = function() require("plugin-configs.which-key") end,
  },
  ["sudormrfbin/cheatsheet.nvim"] = {
    config = function() require("plugin-configs.cheatsheet") end,
  },

  -- Terminal
  ["akinsho/toggleterm.nvim"] = {
    cmd = "ToggleTerm",
    module = { "toggleterm", "toggleterm.terminal" },
    config = function() require("plugin-configs.toggleterm") end,
  },

  -- Git integrations
  ["sindrets/diffview.nvim"] = {
    after = "plenary.nvim",
    config = function() require("plugin-configs.diffview") end,
  },
  ["lewis6991/gitsigns.nvim"] = {
    config = function() require("plugin-configs.gitsigns") end,
  },
  ["rhysd/git-messenger.vim"] = {},
  ["tpope/vim-fugitive"] = {},

  -- Note taking
  ["lervag/vimtex"] = {},

  -- Testing
  ["nvim-neotest/neotest"] = {
    config = function() require("plugin-configs.neotest") end,
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

  -- Debugging
  ["mfussenegger/nvim-dap"] = {
    module = "dap",
    config = function() require("plugin-configs.nvim-dap") end,
  },
  ["rcarriga/nvim-dap-ui"] = {
    requires = "mfussenegger/nvim-dap",
    config = function() require("plugin-configs.nvim-dap-ui") end,
  },
  ["theHamsta/nvim-dap-virtual-text"] = {
    requires = "mfussenegger/nvim-dap",
    config = function() require("plugin-configs.nvim-dap-virtual-text") end,
  },
  ["michaelb/sniprun"] = {
    run = "bash install.sh",
    config = function() require("plugin-configs.sniprun") end,
  },
  ["mxsdev/nvim-dap-vscode-js"] = {
    requires = "mfussenegger/nvim-dap",
    config = function() require("plugin-configs.nvim-dap-vscode-js") end,
  },
  ["jbyuki/one-small-step-for-vimkind"] = {},

  -- Session management
  ["rmagatti/auto-session"] = {
    config = function() require("plugin-configs.auto-session") end,
  },
  ["rmagatti/session-lens"] = {
    after = { "auto-session", "telescope.nvim" },
    config = function() require("plugin-configs.session-lens") end,
  },

  -- Terraform
  ["hashivim/vim-terraform"] = {},
  ["juliosueiras/vim-terraform-completion"] = {},

  -- Plugin Development
  ["folke/neodev.nvim"] = {},
  ["rafcamlet/nvim-luapad"] = {},
}

return M
