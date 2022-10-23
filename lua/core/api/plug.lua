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

return fignvim.plug
