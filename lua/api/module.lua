fignvim.module = {}

---Adds a fignvim module registration to include in later setup
---@param modules table A table of modules to register
function fignvim.module.register_modules(modules) vim.g.fignvim_modules = vim.tbl_deep_extend("force", vim.g.fignvim_modules, modules) end

--- Used in a module spec. Maps a key to a spec for a plugin, so that when the
--- same key is registered in the `fignvim.module.register_modules` call, the plugin will be loaded.
---@param specs table Key value pairs of plugin names (or thereabouts) to plugin specs
---@param module_name string The name of the module to enabled. Must match the parent folder name
---@return
function fignvim.module.enable_registered_plugins(specs, module_name)
  local registered_specs = {}
  local registered_plugins = vim.g.fignvim_modules[module_name]
  for _, plugin_name in ipairs(registered_plugins) do
    table.insert(registered_specs, specs[plugin_name])
  end

  return registered_specs
end

return fignvim.module
