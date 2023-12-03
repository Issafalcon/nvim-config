fignvim.module = {}

---Adds a fignvim module registration to include in later setup
---@param modules table A table of modules to register
function fignvim.module.register_modules(modules) vim.g.fignvim_modules = vim.tbl_deep_extend("force", vim.g.fignvim_modules, modules) end

---Adds a fignvim module registration to include in later setup
---@param modules table A table of modules to register
function fignvim.module.register_plugins(plugins) vim.g.fignvim_plugins = vim.tbl_deep_extend("force", vim.g.fignvim_plugins, plugins) end

return fignvim.module
