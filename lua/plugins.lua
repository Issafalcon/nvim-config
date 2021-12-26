local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system {
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  }
  print "Installing packer close and reopen Neovim..."
  vim.cmd [[packadd packer.nvim]]
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]]

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end

-- Have packer use a popup window
packer.init {
  display = {
    open_fn = function()
      return require("packer.util").float { border = "rounded" }
    end,
  },
}

-- Install your plugins here
return packer.startup(function(use)
  -- My plugins here
  use "wbthomason/packer.nvim" -- Have packer manage itself
  use "nvim-lua/popup.nvim" -- An implementation of the Popup API from vim in Neovim
  use "nvim-lua/plenary.nvim" -- Useful lua functions used ny lots of plugins

  -- Colours and Icons
  use "marko-cerovac/material.nvim" -- Material Colourscheme
  use "christianchiarulli/nvcode-color-schemes.vim" -- VSCode Like ColourScheme
  use "norcalli/nvim-colorizer.lua" -- HEX and RBG etc Colour Highlighter: https://github.com/norcalli/nvim-colorizer.lua
  use "kyazdani42/nvim-web-devicons" -- Vim devicons with colour: https://github.com/kyazdani42/nvim-web-devicons

  -- Key binding / Help plugins
  use "folke/which-key.nvim" -- Key binding help: https://github.com/folke/which-key.nvim  

  -- Git plugins
  use "lewis6991/gitsigns.nvim"
  use "tpope/vim-fugitive"
  use "tpope/vim-rhubarb" -- Browse Github URLs
  use "rhysd/git-messenger.vim" -- Show commits under the cursor
  use "kdheepak/lazygit.nvim"
  use "sindrets/diffview.nvim"

  -- cmp plugins
  use "hrsh7th/nvim-cmp" -- The completion plugin
  use "hrsh7th/cmp-buffer" -- buffer completions
  use "hrsh7th/cmp-path" -- path completions
  use "hrsh7th/cmp-cmdline" -- cmdline completions
  use "hrsh7th/cmp-nvim-lsp" -- LSP completion support
  use "hrsh7th/cmp-nvim-lua" -- Lua in Vim language completions
  use "hrsh7th/cmp-vsnip"
  use "David-Kunz/cmp-npm" -- NPM completions in package.json

  -- LSP
  use "b0o/schemastore.nvim" -- JSON-ls schemas: https://github.com/b0o/SchemaStore.nvim 
  use "neovim/nvim-lspconfig" -- The LSP config
  use "williamboman/nvim-lsp-installer" -- Conveniently install LSPs: https://github.com/williamboman/nvim-lsp-installer
  use  'tami5/lspsaga.nvim' 
  use "ray-x/lsp_signature.nvim"
  use "onsails/lspkind-nvim"

  -- snippets
  use "hrsh7th/vim-vsnip" -- snippet completions
  use "hrsh7th/vim-vsnip-integ"
  use "rafamadriz/friendly-snippets" -- a bunch of snippets to use

  -- Searching
  use "junegunn/fzf"
  use "nvim-telescope/telescope-fzy-native.nvim"
  use  "nvim-telescope/telescope.nvim"  
  use  "kevinhwang91/rnvimr"

  -- File Navigation
  use  "preservim/tagbar"
  use {
    "phaazon/hop.nvim", 
    as = "hop"
  }

  use "junegunn/vim-easy-align"

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end)
