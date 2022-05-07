local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system({
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  })
  print("Installing packer close and reopen Neovim...")
  vim.cmd([[packadd packer.nvim]])
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile>
  augroup end
]])

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end

-- Have packer use a popup window
packer.init({
  display = {
    open_fn = function()
      return require("packer.util").float({ border = "rounded" })
    end,
  },
})

-- Install your plugins here
return packer.startup(function(use)
  -- Essential "base" plugins
  use("wbthomason/packer.nvim") -- Have packer manage itself
  use("nvim-lua/popup.nvim") -- An implementation of the Popup API from vim in Neovim
  use("nvim-lua/plenary.nvim") -- Useful lua functions used ny lots of plugins

  -- Searching
  use("junegunn/fzf")
  use("nvim-telescope/telescope-fzy-native.nvim")
  use("nvim-telescope/telescope.nvim")
  use("windwp/nvim-spectre")

  -- Utility Plugins
  use("windwp/nvim-autopairs") -- Autopair with cmp and treesitter integration
  use("junegunn/vim-easy-align") -- Align text
  use("tpope/vim-surround")
  use("tpope/vim-dispatch")
  use("nvim-lualine/lualine.nvim")
  use("tpope/vim-unimpaired")
  use("editorconfig/editorconfig-vim") -- Applies editorconfig to text
  use("mbbill/undotree")
  use("szw/vim-maximizer")
  use("sudormrfbin/cheatsheet.nvim")
  use({
    "svermeulen/vim-easyclip",
    requires = {
      "tpope/vim-repeat",
    },
  })
  use({
    "rmagatti/session-lens", -- Saves sessions after closing nvim
    requires = { "rmagatti/auto-session", "nvim-telescope/telescope.nvim" },
    config = function()
      require("session-lens").setup()
    end,
  })

  -- Colours and Icons
  use("marko-cerovac/material.nvim") -- Material Colourscheme
  use("lunarvim/colorschemes") -- VSCode Like ColourScheme
  use("norcalli/nvim-colorizer.lua") -- HEX and RBG etc Colour Highlighter: https://github.com/norcalli/nvim-colorizer.lua
  use("kyazdani42/nvim-web-devicons") -- Vim devicons with colour: https://github.com/kyazdani42/nvim-web-devicons

  -- Key binding / Help plugins
  use("folke/which-key.nvim") -- Key binding help: https://github.com/folke/which-key.nvim

  -- Git plugins
  use("lewis6991/gitsigns.nvim")
  use("tpope/vim-fugitive")
  use("tpope/vim-rhubarb") -- Browse Github URLs
  use("rhysd/git-messenger.vim") -- Show commits under the cursor
  use("kdheepak/lazygit.nvim")
  use("sindrets/diffview.nvim")

  -- Github
  use({
    "pwntester/octo.nvim",
    config = function()
      require("octo").setup()
    end,
  })

  -- cmp plugins
  use("hrsh7th/nvim-cmp") -- The completion plugin
  use("hrsh7th/cmp-buffer") -- buffer completions
  use("hrsh7th/cmp-path") -- path completions
  use("hrsh7th/cmp-cmdline") -- cmdline completions
  use("hrsh7th/cmp-nvim-lsp") -- LSP completion support
  use("hrsh7th/cmp-vsnip")

  -- TreeSitter
  use({
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
  })
  use({ "nvim-treesitter/nvim-treesitter-textobjects" })
  use({ "nvim-treesitter/playground" })
  use({ "windwp/nvim-ts-autotag" })
  use({ "p00f/nvim-ts-rainbow" })

  -- LSP
  use("b0o/schemastore.nvim") -- JSON-ls schemas: https://github.com/b0o/SchemaStore.nvim
  use("neovim/nvim-lspconfig") -- The LSP config
  use("williamboman/nvim-lsp-installer") -- Conveniently install LSPs: https://github.com/williamboman/nvim-lsp-installer
  use("tami5/lspsaga.nvim")
  use("ray-x/lsp_signature.nvim")
  use("onsails/lspkind-nvim")
  use("nvim-lua/lsp-status.nvim")
  use("jose-elias-alvarez/null-ls.nvim")

  -- snippets
  use("hrsh7th/vim-vsnip") -- snippet completions
  use("hrsh7th/vim-vsnip-integ")
  use("rafamadriz/friendly-snippets") -- a bunch of snippets to use

  -- Bufferline (depends on nvim-web-devicons installed above)
  use({ "akinsho/bufferline.nvim", requires = "kyazdani42/nvim-web-devicons" })

  -- File Navigation
  use("kyazdani42/nvim-tree.lua")
  use("preservim/tagbar")
  use({
    "phaazon/hop.nvim",
    as = "hop",
  })

  -- Commenting
  use({ "terrortylor/nvim-comment" })
  use({ "JoosepAlviste/nvim-ts-context-commentstring" })
  use({ "kkoomen/vim-doge", run = ":call doge#install()" })

  -- Quickfix / Location lists
  use("kevinhwang91/nvim-bqf")

  -- Terminal
  use("voldikss/vim-floaterm")

  -- Testing tools
  use({
    "rcarriga/vim-ultest",
    requires = { "vim-test/vim-test" },
    run = ":UpdateRemotePlugins",
  })

  -- Debugging
  use("mfussenegger/nvim-dap")
  use("theHamsta/nvim-dap-virtual-text")
  use("nvim-telescope/telescope-dap.nvim")
  use("rcarriga/nvim-dap-ui")

  use({ "michaelb/sniprun", run = "bash install.sh" })

  --------------------------------------------------------------
  ------------ Language Specific Plugins -----------------------
  --------------------------------------------------------------

  -- Typescript / JavaScript (React, Svelte, Angular, TS)
  use("jose-elias-alvarez/nvim-lsp-ts-utils") -- Extends LSP functionality for tsserver
  use("xabikos/vscode-react") -- React snippets
  use("dsznajder/vscode-es7-javascript-react-snippets") -- More react snippets
  use("fivethree-team/vscode-svelte-snippets") -- Svelete snippets
  use("David-Kunz/cmp-npm") -- NPM completions in package.json
  use({ "nvim-treesitter/nvim-treesitter-angular" }) -- Treesitter extension for angular
  use("David-Kunz/jester") -- Debugging Jest tests

  -- Lua / Neovim Plugin Development
  use("hrsh7th/cmp-nvim-lua") -- Lua in Vim language completions
  use("folke/lua-dev.nvim") -- For plugin dev with full signature help, docs and completion for neovim lua apis
  use("rafcamlet/nvim-luapad")

  -- .NET / C#
  use("~/repos/neo-sharper.nvim")
  use("J0rgeSerran0/vscode-csharp-snippets")
  use("Hoffs/omnisharp-extended-lsp.nvim")

  -- Latex
  use("lervag/vimtex")

  -- Markdown
  use({ "iamcco/markdown-preview.nvim", run = "cd app && npm install" })
  use({ "robole/vscode-markdown-snippets" })

  -- Terraform
  use("hashivim/vim-terraform")
  use("juliosueiras/vim-terraform-completion")

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end)
