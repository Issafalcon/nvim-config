fignvim.lsp.null_ls = {}

--- Get a list of registered null-ls providers for a given filetype
---@param filetype string the filetype to search null-ls for
---@return table a list of null-ls sources
function fignvim.lsp.null_ls.providers(filetype)
  local registered = {}
  -- try to load null-ls
  require("null-ls.sources").get_available("lua")
  local sources = fignvim.plug.load_module_file("null-ls.sources")
  if sources then
    -- get the available sources of a given filetype
    for _, source in ipairs(sources.get_available(filetype)) do
      -- get each source name
      for method in pairs(source.methods) do
        registered[method] = registered[method] or {}
        vim.fn.tbl_insert(registered[method], source.name)
      end
    end
  end
  -- return the found null-ls sources
  return registered
end

--- Register a null-ls source given a name if it has not been manually configured in the null-ls configuration
---@param source string the source name to register from all builtin types
function fignvim.lsp.null_ls.register(source)
  -- try to load null-ls
  local null_ls = fignvim.plug.load_module_file("null-ls.sources")
  if null_ls then
    if null_ls.is_registered(source) then return end
    for _, type in ipairs { "diagnostics", "formatting", "code_actions", "completion", "hover" } do
      local builtin = require("null-ls.builtins._meta." .. type)
      if builtin[source] then null_ls.register(null_ls.builtins[type][source]) end
    end
  end
end

--- Get the null-ls sources for a given null-ls method
---@param filetype string The filetype to search null-ls for
---@param method string the null-ls method (check null-ls documentation for available methods)
---@return table the available sources for the given filetype and method
function fignvim.lsp.null_ls.sources(filetype, method)
  local methods_avail, methods = pcall(require, "null-ls.methods")
  return methods_avail and fignvim.lsp.null_ls.providers(filetype)[methods.internal[method]] or {}
end
