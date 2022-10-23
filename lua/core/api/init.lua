_G.fignvim = {}

--- Looks to see if a module path references a lua file in a configuration folder and tries to load it. If there is an error loading the file, write an error and continue
---@param module string the module path to try and load
---@return any the loaded module if successful or nil
fignvim.load_module_file = function(module)
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

--- Main configuration engine logic for extending a default configuration table with either a function override or a table to merge into the default option
-- @param overrides the override definition, either a table or a function that takes a single parameter of the original table
-- @param default the default configuration table
-- @param extend boolean value to either extend the default or simply overwrite it if an override is provided
-- @return the new configuration table
fignvim.func_or_extend = function(overrides, default, extend)
  -- if we want to extend the default with the provided override
  if extend then
    -- if the override is a table, use vim.tbl_deep_extend
    if type(overrides) == "table" then
      default = fignvim.table.default_tbl(overrides, default)
      -- if the override is  a function, call it with the default and overwrite default with the return value
    elseif type(overrides) == "function" then
      default = overrides(default)
    end
    -- if extend is set to false and we have a provided override, simply override the default
  elseif overrides ~= nil then
    default = overrides
  end
  -- return the modified default table
  return default
end

--- Settings from the base `config/init.lua` file
fignvim.config = fignvim.load_module_file("config.init")

--- regex used for matching a valid URL/URI string
fignvim.url_matcher =
"\\v\\c%(%(h?ttps?|ftp|file|ssh|git)://|[a-z]+[@][a-z]+[.][a-z]+:)%([&:#*@~%_\\-=?!+;/0-9a-z]+%(%([.;/?]|[.][.]+)[&:#*@~%_\\-=?!+/0-9a-z]+|:\\d+|,%(%(%(h?ttps?|ftp|file|ssh|git)://|[a-z]+[@][a-z]+[.][a-z]+:)@![0-9a-z]+))*|\\([&:#*@~%_\\-=?!+;/.0-9a-z]*\\)|\\[[&:#*@~%_\\-=?!+;/.0-9a-z]*\\]|\\{%([&:#*@~%_\\-=?!+;/.0-9a-z]*|\\{[&:#*@~%_\\-=?!+;/.0-9a-z]*})\\})+"

--- Search the user settings (user/init.lua table) for a table with a module like path string
---@param module string the module path like string to look up in the user settings table
---@return table the value of the table entry if exists or nil
fignvim.config_table = function(module)
  -- get the user settings table
  local config = fignvim.config or {}
  -- iterate over the path string split by '.' to look up the table value
  for tbl in string.gmatch(module, "([^%.]+)") do
    config = config[tbl]
    -- if key doesn't exist, keep the nil value and stop searching
    if config == nil then break end
  end
  -- return the found settings
  return config
end
