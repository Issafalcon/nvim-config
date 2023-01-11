fignvim.plug = {}

--- Check if a plugin is defined in packer. Useful with lazy loading when a plugin is not necessarily loaded yet
---@param plugin string the plugin string to search for
---@return boolean value if the plugin is available
function fignvim.plug.is_available()
  return true
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
  -- try loading lazy.nvim
  local lazy_avail, _ = pcall(require, "lazy")
  -- if packer isn't availble, reinstall it
  if not lazy_avail then
    -- set the location to install packer
    local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
    -- delete the old packer install if one exists
    vim.fn.delete(lazypath, "rf")
    if not vim.loop.fs_stat(lazypath) then
      vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
      })
    end
    fignvim.ui.echo({ { "Initializing Lazy.nvim...\n\n" } })
  end
end

function fignvim.plug.setup_lazy_plugins()
  local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
  vim.opt.rtp:prepend(lazypath)

  local status_ok, lazy = pcall(require, "lazy")
  if status_ok then
    local plugins = {}

    for key, plugin in pairs(require("user-configs.plugins").plugins) do
      if type(key) == "string" and not plugin[1] then
        plugin[1] = key
      end
      table.insert(plugins, plugin)
    end
    lazy.setup({
      spec = {
        plugins,
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

return fignvim.plug
