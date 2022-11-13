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
        -- Utility Plugins
        use("mbbill/undotree")
        use("szw/vim-maximizer")
        use("lukas-reineke/indent-blankline.nvim")
        use("ThePrimeagen/refactoring.nvim")
        use({ "svermeulen/vim-easyclip" })

        -- UI Plugins (colours, icons, inputs etc)
        use("ziontee113/icon-picker.nvim")
        use("norcalli/nvim-colorizer.lua") -- HEX and RBG etc Colour Highlighter: https://github.com/norcalli/nvim-colorizer.lua

        -- Session management
        use({
          "rmagatti/session-lens", -- Saves sessions after closing nvim
          requires = { "rmagatti/auto-session", "nvim-telescope/telescope.nvim" },
        })

        -- LSP
        use("b0o/schemastore.nvim") -- JSON-ls schemas: https://github.com/b0o/SchemaStore.nvim
        use("Issafalcon/lsp-overloads.nvim")

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

        -- Debugging
        use("mfussenegger/nvim-dap")
        use("theHamsta/nvim-dap-virtual-text")
        use("nvim-telescope/telescope-dap.nvim")
        use("rcarriga/nvim-dap-ui")

        use({ "michaelb/sniprun", run = "bash install.sh" })

        --------------------------------------------------------------
        ------------ Language Specific Plugins -----------------------
        --------------------------------------------------------------

        -- Lua / Neovim Plugin Development
        -- Typescript / JavaScript (React, Svelte, Angular, TS)plug
        use("jose-elias-alvarez/nvim-lsp-ts-utils") -- Extends LSP functionality for tsserver

        use("folke/neodev.nvim") -- For plugin dev with full signature help, docs and completion for neovim lua apis
        use("rafcamlet/nvim-luapad")

        -- .NET / C#
        use({ "Issafalcon/neo-sharper.nvim", branch = "plugin-testing" })
        use("Hoffs/omnisharp-extended-lsp.nvim")

        -- Markdown
        use({ "iamcco/markdown-preview.nvim", run = "cd app && npm install" })

        -- Terraform
        use("hashivim/vim-terraform")
        use("juliosueiras/vim-terraform-completion")

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
  local plugin_mapping_dictionary = {
    ["Comment.nvim"] = "Commenting",
    ["toggleterm.nvim"] = "Terminal",
    ["vim-easy-align"] = "EasyAlign",
    ["telescope.nvim"] = "Searching",
    ["aerial.nvim"] = "Aerial",
    ["neo-tree.nvim"] = "NeoTree",
    ["nvim-spectre"] = "Searching",
    ["nvim-cmp"] = "Completion",
    ["LuaSnip"] = "Snippets",
    ["copilot.vim"] = "Copilot",
    ["diffview.nvim"] = "Diffview",
    ["vimtex"] = "LaTex",
    ["neotest"] = "Neotest",
    ["cheatsheet.nvim"] = "Cheatsheet",
  }

  for plugin, groupname in pairs(plugin_mapping_dictionary) do
    if fignvim.plug.is_available(plugin) then
      local mappings = fignvim.config.get_plugin_mappings(plugin)
      fignvim.fn.conditional_func(fignvim.config.create_mapping_group, mappings ~= nil, mappings, groupname)
    end
  end
end

--- Special mapping callback for git_signs so mappings are created per buffer during the on_attach callback
---@param bufnr number The buffer number to create mappings for
function fignvim.plug.gitsigns_on_attach_cb(bufnr)
  local plugin = "gitsigns.nvim"
  local mappings = fignvim.config.get_plugin_mappings(plugin)
  fignvim.fn.conditional_func(fignvim.config.create_mapping_group, mappings ~= nil, mappings, "Gitsigns", bufnr)
end

return fignvim.plug
