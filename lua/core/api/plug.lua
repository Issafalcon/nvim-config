fignvim.plug = {}

--- default packer compilation location to be used in bootstrapping and packer setup call
fignvim.plug.default_compile_path = vim.fn.stdpath("data" .. "/packer_compiled.lua")

--- Entrypoint for plugin config override and extension based on the configuration options applied in config/init.lua
---@param module string the module path of the override setting
---@param default table the default settings that will be overridden
---@param extend boolean value to either extend the default settings or overwrite them with the user settings entirely (default: true)
---@return table the new configuration settings with the config overrides
fignvim.plug.opts = function(module, default, extend)
  -- default to extend = true
  if extend == nil then extend = true end
  -- if no default table is provided set it to an empty table
  default = default or {}

  local plug_config = fignvim.config_table(module)

  if plug_config ~= nil then default = fignvim.func_or_extend(plug_config, default, extend) end
  -- return the final configuration table with any overrides applied
  return default
end

--- Check if packer is installed and loadable, if not then install it and make sure it loads
fignvim.plug.initialise_packer = function()
  -- try loading packer
  local packer_avail, _ = pcall(require, "packer")
  -- if packer isn't availble, reinstall it
  if not packer_avail then
    -- set the location to install packer
    local packer_path = vim.fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
    -- delete the old packer install if one exists
    vim.fn.delete(packer_path, "rf")
    -- clone packer
    vim.fn.system {
      "git",
      "clone",
      "--depth",
      "1",
      "https://github.com/wbthomason/packer.nvim",
      packer_path,
    }
    fignvim.ui.echo { { "Initializing Packer...\n\n" } }
    -- add packer and try loading it
    vim.cmd.packadd "packer.nvim"
    packer_avail, _ = pcall(require, "packer")
    -- if packer didn't load, print error
    if not packer_avail then vim.api.nvim_err_writeln("Failed to load packer at:" .. packer_path) end
  end
  -- if packer is available, check if there is a compiled packer file
  if packer_avail then
    -- try to load the packer compiled file
    local run_me, _ = loadfile(
      astronvim.user_plugin_opts("plugins.packer", { compile_path = astronvim.default_compile_path }).compile_path
    )
    -- if the file loads, run the compiled function
    if run_me then
      run_me()
      -- if there is no compiled file, prompt the user to run :PackerSync
    else
      astronvim.echo { { "Please run " }, { ":PackerSync", "Title" } }
    end
  end
end

return fignvim.plug
