fignvim.plug = {}

fignvim.plug.default_compile_path = vim.fn.stdpath("data" .. "/packer_compiled.lua")
fignvim.plug.default_snapshot_path = vim.fn.stdpath("config" .. "/packer_snapshots")

--- Check if a plugin is defined in packer. Useful with lazy loading when a plugin is not necessarily loaded yet
---@param plugin string the plugin string to search for
---@return boolean value if the plugin is available
function fignvim.plug.is_available(plugin)
  return packer_plugins ~= nil and packer_plugins[plugin] ~= nil
end

--- Looks to see if a module path references a lua file in a configuration folder and tries to load it. If there is an error loading the file, write an error and continue
---@param module string the module path to try and load
---@param required? boolean Whether the module is essential for core operations or not (default: false)
---@return any the loaded module if successful or nil. Errors if the module is required and fails to load
function fignvim.plug.load_module_file(module, required)
  local found_module
  local status_ok, loaded_module = pcall(require, module)

  if status_ok then
    found_module = loaded_module
  elseif required then
    vim.api.nvim_err_writeln("Error loading file: " .. found_module .. "\n\n" .. loaded_module)
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

return fignvim.plug
