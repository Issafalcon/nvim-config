fignvim.plug = {}

--- default packer compilation location to be used in bootstrapping and packer setup call
fignvim.plug.default_compile_path = vim.fn.stdpath("data" .. "/packer_compiled.lua")

--- Check if a plugin is defined in packer. Useful with lazy loading when a plugin is not necessarily loaded yet
---@param plugin string the plugin string to search for
---@return boolean value if the plugin is available
function fignvim.plug.is_available(plugin) return packer_plugins ~= nil and packer_plugins[plugin] ~= nil end

--- Looks to see if a module path references a lua file in a configuration folder and tries to load it. If there is an error loading the file, write an error and continue
---@param module string the module path to try and load
---@return any the loaded module if successful or nil
function fignvim.plug.load_module_file(module)
  local found_module
  -- try to load the file
  local status_ok, loaded_module = pcall(require, module)
  -- if successful at loading, set the return variable
  if status_ok then
    found_module = loaded_module
    -- if unsuccessful, throw an error
  else
    vim.api.nvim_err_writeln("Error loading file: " .. found_module .. "\n\n" .. loaded_module)
  end
  -- return the loaded module or nil if no file found
  return found_module
end

--- Check if packer is installed and loadable, if not then install it and make sure it loads
fignvim.plug.initialise_packer = function()
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
    local run_me, _ =
      loadfile(fignvim.plug.opts("plugins.packer", { compile_path = fignvim.plug.default_compile_path }).compile_path)
    -- if the file loads, run the compiled function
    if run_me then
      run_me()
      -- if there is no compiled file, prompt the user to run :PackerSync
    else
      fignvim.ui.echo({ { "Please run " }, { ":PackerSync", "Title" } })
    end
  end
end

return fignvim.plug
