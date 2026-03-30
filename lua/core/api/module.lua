fignvim.core.module = {}

---Adds a fignvim module registration to include in later setup
---@param modules table A table of modules to register
function fignvim.core.module.register_modules(modules)
  vim.g.fignvim_modules = vim.tbl_deep_extend("force", vim.g.fignvim_modules, modules)
end

---Adds a fignvim module registration to include in later setup
---@param modules table A table of modules to register
function fignvim.core.module.register_plugins(plugins)
  vim.g.fignvim_plugins = vim.tbl_deep_extend("force", vim.g.fignvim_plugins, plugins)
end

function fignvim.core.module.import_module_lazy_plugin_specs()
  local imports = {}
  for _, module_name in ipairs(vim.g.fignvim_modules) do
    local status_ok, _ = pcall(require, module_name .. ".lazy-spec")
    if status_ok then
      table.insert(imports, { import = module_name .. ".lazy-spec" })
    end
  end

  return imports
end

function fignvim.core.module.load_module_apis()
  for _, module_name in ipairs(vim.g.fignvim_modules) do
    local status_ok, _ = pcall(require, module_name .. ".api")
    if status_ok then
      require(module_name .. ".api")
    end
  end
end

return fignvim.core.module
