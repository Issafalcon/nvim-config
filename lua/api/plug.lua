fignvim.plug = {}
fignvim.plug.default_compile_path = vim.fn.stdpath("data") .. "/packer_compiled.lua"
fignvim.plug.default_snapshot_path = vim.fn.stdpath("config") .. "/packer_snapshots"

-- Plugins to load when file opened
fignvim.plug.file_plugins = {}

--- Check if a plugin is defined in packer. Useful with lazy loading when a plugin is not necessarily loaded yet
---@param plugin string the plugin string to search for
---@return boolean value if the plugin is available
function fignvim.plug.is_available(plugin) return packer_plugins ~= nil and packer_plugins[plugin] ~= nil end

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

--- Special mapping callback for git_signs so mappings are created per buffer during the on_attach callback
---@param bufnr number The buffer number to create mappings for
function fignvim.plug.gitsigns_on_attach_cb(bufnr)
  local plugin = "gitsigns.nvim"
  local mappings = fignvim.config.get_plugin_mappings(plugin)
  for _, map in pairs(mappings) do
    fignvim.config.create_mapping(map, bufnr)
  end
end

function fignvim.plug.initialise_lazy_nvim()
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=v7.9.0",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
end

function fignvim.plug.setup_lazy_plugins()
  local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
  vim.opt.rtp:prepend(lazypath)

  local status_ok, lazy = pcall(require, "lazy")
  if status_ok then
    lazy.setup({
      spec = {
        { import = "plugins" },
      },
      defaults = {
        lazy = false,
      },
      dev = {
        path = "$PROJECTS",
        ---@type string[] plugins that match these patterns will use your local versions instead of being fetched from GitHub
        patterns = {},
      },
      checker = {
        enabled = true,
      },
      install = { colorscheme = { "catppuccin" } },
      diff = {
        cmd = "diffview.nvim",
      },
      performance = {
        cache = {
          enabled = true,
          -- disable_events = {},
        },
        rtp = {
          disabled_plugins = {
            "gzip",
            "matchit",
            "matchparen",
            "netrwPlugin",
            "tarPlugin",
            "tohtml",
            "tutor",
            "zipPlugin",
          },
        },
      },
    })
  end
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
    if not packer_avail then vim.api.nvim_err_writeln("Failed to load packer at:" .. packer_path) end
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
        for key, plugin in pairs(require("user-configs.plugins").plugins) do
          if type(key) == "string" and not plugin[1] then plugin[1] = key end
          use(plugin)
        end
      end,
      config = {
        compile_path = fignvim.plug.default_compile_path,
        snapshot_path = fignvim.plug.default_snapshot_path,
        display = {
          open_fn = function() return require("packer.util").float({ border = "rounded" }) end,
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

return fignvim.plug
