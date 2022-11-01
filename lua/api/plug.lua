fignvim.plug = {}

fignvim.plug.default_compile_path = vim.fn.stdpath("data") .. "/packer_compiled.lua"
fignvim.plug.default_snapshot_path = vim.fn.stdpath("config") .. "/packer_snapshots"

--- Check if a plugin is defined in packer. Useful with lazy loading when a plugin is not necessarily loaded yet
---@param plugin string the plugin string to search for
---@return boolean value if the plugin is available
function fignvim.plug.is_available(plugin)
  return packer_plugins ~= nil and packer_plugins[plugin] ~= nil
end

--- Looks to see if a module path references a lua file in a configuration folder and tries to load it. If there is an error loading the file, write an error and continue
---@param module string the module path to try and load
---@param required? boolean Whether the module is essential for core operations or not (default: false)
---@return table the loaded module if successful or nil. Errors if the module is required and fails to load
function fignvim.plug.load_module_file(module, required)
  local found_module
  local status_ok, loaded_module = pcall(require, module)

  if status_ok then
    found_module = loaded_module
  elseif not status_ok and required then
    vim.api.nvim_err_writeln("Error loading file: " .. module .. "\n\n" .. loaded_module)
  end

  return found_module
end

--- Check if packer is installed and loadable, if not then install it and make sure it loads
function fignvim.plug.initialise_packer()
  -- try loading packer
  local packer_avail, _ = pcall(require, "packer")
  -- if packer isn't availble, reinstall it
  if not packer_avail then
    -- set the location to install packer
    local packer_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
    -- delete the old packer install if one exists
    vim.fn.delete(packer_path, "rf")
    -- clone packer
    vim.fn.system({
      "git",
      "clone",
      "--depth",
      "1",
      "https://github.com/wbthomason/packer.nvim",
      packer_path,
    })
    fignvim.ui.echo({ { "Initializing Packer...\n\n" } })
    -- add packer and try loading it
    vim.cmd.packadd("packer.nvim")
    packer_avail, _ = pcall(require, "packer")
    -- if packer didn't load, print error
    if not packer_avail then
      vim.api.nvim_err_writeln("Failed to load packer at:" .. packer_path)
    end
  end
  -- if packer is available, check if there is a compiled packer file
  if packer_avail then
    -- try to load the packer compiled file
    local run_me, _ = loadfile(fignvim.plug.default_compile_path)
    -- if the file loads, run the compiled function
    if run_me then
      run_me()
      -- if there is no compiled file, prompt the user to run :PackerSync
    else
      fignvim.ui.echo({ { "Please run " }, { ":PackerSync", "Title" } })
    end
  end
end

function fignvim.plug.setup_plugins()
  local status_ok, packer = pcall(require, "packer")
  if status_ok then
    packer.startup({
      function(use)
        -- Searching
        use("junegunn/fzf")
        use("nvim-telescope/telescope-fzy-native.nvim")
        use("nvim-telescope/telescope.nvim")
        use("windwp/nvim-spectre")

        -- Utility Plugins
        use("mbbill/undotree")
        use("szw/vim-maximizer")
        use("sudormrfbin/cheatsheet.nvim")
        use("lukas-reineke/indent-blankline.nvim")
        use("ThePrimeagen/refactoring.nvim")
        use({ "svermeulen/vim-easyclip" })

        -- UI Plugins (colours, icons, inputs etc)
        use("ziontee113/icon-picker.nvim")
        use({ "catppuccin/nvim", as = "catppuccin" })
        use("norcalli/nvim-colorizer.lua") -- HEX and RBG etc Colour Highlighter: https://github.com/norcalli/nvim-colorizer.lua

        -- Session management
        use({
          "rmagatti/session-lens", -- Saves sessions after closing nvim
          requires = { "rmagatti/auto-session", "nvim-telescope/telescope.nvim" },
        })

        -- Git plugins
        use("lewis6991/gitsigns.nvim")
        use("tpope/vim-fugitive")
        use("tpope/vim-rhubarb") -- Browse Github URLs
        use("rhysd/git-messenger.vim") -- Show commits under the cursor
        use("sindrets/diffview.nvim")

        -- Github
        use({
          "pwntester/octo.nvim",
          config = function()
            require("octo").setup()
          end,
        })
        use("github/copilot.vim")

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
        use("nvim-lua/lsp-status.nvim")
        use("Issafalcon/lsp-overloads.nvim")

        -- snippets
        use({ "L3MON4D3/LuaSnip" }) -- Best snippet engine
        use("saadparwaiz1/cmp_luasnip")
        use("rafamadriz/friendly-snippets") -- a bunch of snippets to use

        -- File Navigation
        use("ThePrimeagen/harpoon")
        if vim.fn.has("wsl") == 1 or vim.fn.has("unix") == 1 then
          use("kevinhwang91/rnvimr")
        end
        use({
          "phaazon/hop.nvim",
          as = "hop",
        })

        use({ "danymat/neogen" })

        -- Quickfix / Location lists
        use("kevinhwang91/nvim-bqf")

        use({
          "nvim-neotest/neotest",
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
        use("David-Kunz/jester") -- Debugging Jest tests

        -- Lua / Neovim Plugin Development
        use("hrsh7th/cmp-nvim-lua") -- Lua in Vim language completions
        use("folke/neodev.nvim") -- For plugin dev with full signature help, docs and completion for neovim lua apis
        use("rafcamlet/nvim-luapad")

        -- .NET / C#
        use({ "Issafalcon/neo-sharper.nvim", branch = "plugin-testing" })
        use("J0rgeSerran0/vscode-csharp-snippets")
        use("Hoffs/omnisharp-extended-lsp.nvim")

        -- Latex
        use("lervag/vimtex")
        use("jbyuki/nabla.nvim")

        -- Markdown
        use({ "iamcco/markdown-preview.nvim", run = "cd app && npm install" })
        use({ "robole/vscode-markdown-snippets" })

        -- Terraform
        use("hashivim/vim-terraform")
        use("juliosueiras/vim-terraform-completion")

        -- SQL
        use("nanotee/sqls.nvim")
        for key, plugin in pairs(require("user-configs.plugins").plugins) do
          if type(key) == "string" and not plugin[1] then
            plugin[1] = key
          end
          use(plugin)
        end
      end,
      config = {
        compile_path = fignvim.plug.default_compile_path,
        snapshot_path = fignvim.plug.default_snapshot_path,
        display = {
          open_fn = function()
            return require("packer.util").float({ border = "rounded" })
          end,
        },
        profile = {
          enable = true,
          threshold = 0.0001,
        },
        git = {
          clone_timeout = 300,
          subcommands = {
            update = "pull --rebase",
          },
        },
        auto_clean = true,
        compile_on_sync = true,
      },
    })
  end
end

function fignvim.plug.create_plugin_mappings()
  if fignvim.plug.is_available("Comment.nvim") then
    local mappings = fignvim.config.get_plugin_mappings("Comment")
    fignvim.fn.conditional_func(fignvim.config.create_mapping_group, mappings ~= nil, mappings, "Commenting")
  end

  if fignvim.plug.is_available("toggleterm.nvim") then
    local mappings = fignvim.config.get_plugin_mappings("toggleterm.nvim")
    fignvim.fn.conditional_func(fignvim.config.create_mapping_group, mappings ~= nil, mappings, "Terminal")
  end

  if fignvim.plug.is_available("vim-easy-align") then
    local mappings = require("user-configs.mappings").plugin_mappings["vim-easy-align"]
    fignvim.config.create_mapping_group(mappings, "EasyAlign")
  end
end

return fignvim.plug
