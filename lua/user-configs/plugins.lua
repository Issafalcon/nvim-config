M = {}

M.plugins = {
  -- Plugin manager
  -- NOT NEEDED
  ["wbthomason/packer.nvim"] = {}, -- https://github.com/wbthomason/packer.nvim

  -- Optimiser
  -- NOT NEEDED
  ["lewis6991/impatient.nvim"] = {}, -- https://github.com/lewis6991/impatient.nvim

  -- Lua functions
  -- DONE
  ["nvim-lua/plenary.nvim"] = {}, -- https://github.com/nvim-lua/plenary.nvim

  -- Background compilation / script runnerplugins
  -- Maybe not needed
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
  -- DONE
  ["aklt/plantuml-syntax"] = {
    opt = true,
    setup = function() table.insert(fignvim.plug.file_plugins, "plantuml-syntax") end,
  },
  -- DONE
  ["weirongxu/plantuml-previewer.vim"] = {
    opt = true,
    requires = {
      "tyru/open-browser.vim",
    },
    setup = function() table.insert(fignvim.plug.file_plugins, "plantuml-previewer.vim") end,
  },

  -- Icons
  -- DONE
  ["nvim-tree/nvim-web-devicons"] = {
    -- https://github.com/nvim-tree/nvim-web-devicons
    disable = not vim.g.icons_enabled,
    module = "nvim-web-devicons",
    config = function() require("plugin-configs.nvim-web-devicons") end,
  },
  -- DONE
  ["onsails/lspkind.nvim"] = {
    disable = not vim.g.icons_enabled,
    module = "lspkind",
    config = function() require("plugin-configs.lspkind") end,
  },

  -- Windows, Buffers and Tabs
  -- DONE
  ["szw/vim-maximizer"] = {
    cmd = "MaximizerToggle",
  },
  -- DONE
  ["akinsho/bufferline.nvim"] = {
    -- https://github.com/akinsho/bufferline.nvim
    event = "UIEnter",
    config = function() require("plugin-configs.bufferline") end,
  },
  -- DONE
  ["s1n7ax/nvim-window-picker"] = {
    tag = "v1.*",
    module = "window-picker",
    config = function() require("configs.window-picker") end,
  },

  -- Navigation
  -- DONE
  ["nvim-neo-tree/neo-tree.nvim"] = {
    -- https://github.com/nvim-neo-tree/neo-tree.nvim/tree/v2.x
    branch = "v2.x",
    requires = { { "MunifTanjim/nui.nvim", module = "nui" } },
    setup = function() vim.g.neo_tree_remove_legacy_commands = true end,
    config = function() require("plugin-configs.neo-tree") end,
  },
  -- DONE
  ["kevinhwang91/rnvimr"] = {
    cmd = "RnvimrToggle",
    cond = function() return vim.fn.executable("ranger") == 1 end,
  },
  -- DONE
  ["ggandor/leap.nvim"] = {
    config = function() require("plugin-configs.leap") end,
  },
  -- DONE
  ["mbbill/undotree"] = {
    cmd = "UndotreeToggle",
  },

  -- Quickfix / Location List
  -- DONE
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
  -- DONE
  ["windwp/nvim-spectre"] = {
    config = function() require("plugin-configs.spectre") end,
  },

  -- Snippets
  -- DONE
  ["rafamadriz/friendly-snippets"] = {
    opt = true,
  },
  -- DONE
  ["robole/vscode-markdown-snippets"] = { opt = true },
  -- DONE
  ["J0rgeSerran0/vscode-csharp-snippets"] = { opt = true },
  -- DONE
  ["dsznajder/vscode-es7-javascript-react-snippets"] = { opt = true },
  -- DONE
  ["fivethree-team/vscode-svelte-snippets"] = { opt = true },
  -- DONE
  ["xabikos/vscode-react"] = { opt = true },
  -- DONE
  ["L3MON4D3/LuaSnip"] = {
    module = "luasnip",
    wants = "friendly-snippets",
    config = function() require("plugin-configs.LuaSnip") end,
  },

  -- Markdown editing
  -- DONE
  ["iamcco/markdown-preview.nvim"] = {
    run = "cd app && npm install",
  },

  -- .NET / C# development specific
  -- ["~/repos/neo-sharper.nvim"] = {
  --   config = function()
  --     require("neo-sharper").setup()
  --   end,
  -- },

  -- DONE
  ["Hoffs/omnisharp-extended-lsp.nvim"] = {},

  -- Completion engine and sources
  -- DONE
  ["hrsh7th/nvim-cmp"] = {
    config = function() require("plugin-configs.nvim-cmp") end,
  },
  -- DONE
  ["saadparwaiz1/cmp_luasnip"] = {
    after = "nvim-cmp",
  },
  -- DONE
  ["hrsh7th/cmp-buffer"] = {
    after = "nvim-cmp",
  },
  -- DONE
  ["hrsh7th/cmp-cmdline"] = {
    after = "nvim-cmp",
  },
  -- DONE
  ["hrsh7th/cmp-path"] = {
    after = "nvim-cmp",
  },
  -- DONE
  ["hrsh7th/cmp-nvim-lsp"] = {
    after = "nvim-cmp",
  },
  -- DONE
  ["hrsh7th/cmp-nvim-lua"] = {
    after = "nvim-cmp",
  },
  -- DONE
  ["David-Kunz/cmp-npm"] = {
    after = "nvim-cmp",
  },
  -- DONE
  ["lukas-reineke/cmp-rg"] = {
    after = "nvim-cmp",
  },

  -- Copilot
  -- DONE
  ["github/copilot.vim"] = {
    commit = "1bfbaf5b027ee4d3d3dbc828c8bfaef2c45d132d",
  },

  -- Statusline
  -- DONE
  ["rebelot/heirline.nvim"] = {
    config = function() require("plugin-configs.heirline") end,
  },

  -- Treesitter (syntax highlighting and more)
  -- DONE
  ["p00f/nvim-ts-rainbow"] = { after = "nvim-treesitter" },
  -- DONE
  ["windwp/nvim-ts-autotag"] = { after = "nvim-treesitter" },
  -- DONE
  ["JoosepAlviste/nvim-ts-context-commentstring"] = { after = "nvim-treesitter" },
  -- DONE
  ["nvim-treesitter/nvim-treesitter-textobjects"] = { after = "nvim-treesitter" },
  -- DONE
  ["nvim-treesitter/playground"] = { after = "nvim-treesitter" },
  -- DONE
  ["nvim-treesitter/nvim-treesitter"] = {
    run = function() require("nvim-treesitter.install").update({ with_sync = true }) end,
    event = "BufEnter",
    config = function() require("plugin-configs.nvim-treesitter") end,
  },

  -- Commenting
  -- DONE
  ["numToStr/Comment.nvim"] = {
    module = { "Comment", "Comment.api" },
    keys = { "gc", "gb", "g<", "g>" },
    config = function() require("plugin-configs.Comment") end,
  },
  -- DONE
  ["danymat/neogen"] = {
    module = "neogen",
    config = function() require("plugin-configs.neogen") end,
  },

  -- General editing and formatting
  -- DONE
  ["junegunn/vim-easy-align"] = {},
  -- NOT NEEDED
  ["AckslD/nvim-neoclip.lua"] = {
    config = function() require("plugin-configs.nvim-neoclip") end,
  },
  -- DONE
  ["tpope/vim-surround"] = {}, -- https://github.com/tpope/vim-surround
  -- DONE
  ["tpope/vim-unimpaired"] = {}, -- https://github.com/tpope/vim-unimpaired
  -- DONE
  ["windwp/nvim-autopairs"] = {
    event = "InsertEnter",
    config = function() require("plugin-configs.nvim-autopairs") end,
  },
  -- DONE
  ["editorconfig/editorconfig-vim"] = {},
  -- DONE
  ["lukas-reineke/indent-blankline.nvim"] = {
    event = "BufEnter",
    config = function() require("plugin-configs.indent-blankline") end,
  },

  -- DONE
  ["ziontee113/icon-picker.nvim"] = {
    config = function() require("plugin-configs.icon-picker") end,
  },
  -- DONE
  ["svermeulen/vim-cutlass"] = {},
  -- DONE
  ["svermeulen/vim-subversive"] = {},
  -- DONE
  ["tpope/vim-abolish"] = {},
  -- DONE
  ["ThePrimeagen/refactoring.nvim"] = {},

  -- Package management
  -- DONE
  ["williamboman/mason.nvim"] = {
    config = function() require("plugin-configs.mason") end,
  },
  -- DONE
  ["williamboman/mason-lspconfig.nvim"] = {
    after = "mason.nvim",
    config = function() require("plugin-configs.mason-lspconfig") end,
  },
  -- DONE
  ["WhoIsSethDaniel/mason-tool-installer.nvim"] = {
    config = function() require("plugin-configs.mason-tool-installer") end,
  },

  -- LSP
  -- DONE
  ["neovim/nvim-lspconfig"] = {},
  -- DONE
  ["jose-elias-alvarez/null-ls.nvim"] = {
    event = "BufEnter",
    config = function() require("plugin-configs.null-ls") end,
  },
  -- DONE
  ["stevearc/aerial.nvim"] = {
    module = "aerial",
    before = "telescope.nvim",
    config = function() require("plugin-configs.aerial") end,
  },
  -- DONE
  ["jose-elias-alvarez/nvim-lsp-ts-utils"] = {},
  -- DONE
  ["Issafalcon/lsp-overloads.nvim"] = {},
  -- DONE
  ["b0o/schemastore.nvim"] = {},

  -- Diagnostics
  -- DONE
  ["folke/trouble.nvim"] = {
    config = function() require("plugin-configs.trouble") end,
  },

  -- Keybindings / Cheatsheets / Help
  -- DONE
  ["mrjones2014/legendary.nvim"] = {},
  -- DONE
  ["folke/which-key.nvim"] = {
    module = "which-key",
    config = function() require("plugin-configs.which-key") end,
  },
  -- DONE
  ["sudormrfbin/cheatsheet.nvim"] = {
    config = function() require("plugin-configs.cheatsheet") end,
  },

  -- Terminal
  -- DONE
  ["akinsho/toggleterm.nvim"] = {
    cmd = "ToggleTerm",
    module = { "toggleterm", "toggleterm.terminal" },
    config = function() require("plugin-configs.toggleterm") end,
  },

  -- Git integrations
  -- DONE
  ["sindrets/diffview.nvim"] = {
    after = "plenary.nvim",
    config = function() require("plugin-configs.diffview") end,
  },
  -- DONE
  ["lewis6991/gitsigns.nvim"] = {
    config = function() require("plugin-configs.gitsigns") end,
  },
  -- DONE
  ["rhysd/git-messenger.vim"] = {},
  -- DONE
  ["tpope/vim-fugitive"] = {},

  -- Note taking
  -- DONE
  ["lervag/vimtex"] = {},

  -- Testing
  -- DONE
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
  -- DONE
  ["mfussenegger/nvim-dap"] = {
    module = "dap",
    config = function() require("plugin-configs.nvim-dap") end,
  },
  -- DONE
  ["rcarriga/nvim-dap-ui"] = {
    requires = "mfussenegger/nvim-dap",
    config = function() require("plugin-configs.nvim-dap-ui") end,
  },
  -- DONE
  ["theHamsta/nvim-dap-virtual-text"] = {
    requires = "mfussenegger/nvim-dap",
    config = function() require("plugin-configs.nvim-dap-virtual-text") end,
  },
  -- NOT NEEDED
  ["michaelb/sniprun"] = {
    run = "bash install.sh",
    config = function() require("plugin-configs.sniprun") end,
  },
  -- DONE
  ["mxsdev/nvim-dap-vscode-js"] = {
    requires = "mfussenegger/nvim-dap",
    config = function() require("plugin-configs.nvim-dap-vscode-js") end,
  },
  -- DONE
  ["jbyuki/one-small-step-for-vimkind"] = {},

  -- Session management
  -- DONE
  ["rmagatti/auto-session"] = {
    config = function() require("plugin-configs.auto-session") end,
  },
  -- DONE
  ["rmagatti/session-lens"] = {
    after = { "auto-session", "telescope.nvim" },
    config = function() require("plugin-configs.session-lens") end,
  },

  -- Terraform
  -- DONE
  ["hashivim/vim-terraform"] = {},
  -- DONE
  ["juliosueiras/vim-terraform-completion"] = {},

  -- Plugin Development
  -- DONE
  ["folke/neodev.nvim"] = {},
  -- DONE
  ["rafcamlet/nvim-luapad"] = {},
}

return M
