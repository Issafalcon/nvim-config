fignvim.module = {}

---Adds a fignvim module registration to include in later setup
---@param module_tbl table
function fignvim.module.register_modules(modules)
  vim.g.fignvim_modules = vim.tbl_deep_extend("force", vim.g.fignvim_modules, modules)
end

function fignvim.module.enable_registered_plugins(specs, module_name)
  local registered_specs = {}
  local registered_plugins = vim.g.fignvim_modules[module_name]
  for _, plugin_name in ipairs(registered_plugins) do
    table.insert(registered_specs, specs[plugin_name])
  end

  return registered_specs
end

return fignvim.module
