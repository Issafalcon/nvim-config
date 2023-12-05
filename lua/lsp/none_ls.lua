fignvim.lsp.none_ls = {}

--- Get a list of registered null-ls providers for a given filetype
---@param filetype string the filetype to search null-ls for
---@return table a list of null-ls sources
function fignvim.lsp.none_ls.providers(filetype)
  local registered = {}
  -- try to load null-ls
  local sources = require("null-ls.sources")
  if sources then
    -- get the available sources of a given filetype
    for _, source in ipairs(sources.get_available(filetype)) do
      -- get each source name
      for method in pairs(source.methods) do
        registered[method] = registered[method] or {}
        table.insert(registered[method], source.name)
      end
    end
  end
  -- return the found null-ls sources
  return registered
end

--- Get the null-ls sources for a given null-ls method
---@param filetype string The filetype to search null-ls for
---@param method string the null-ls method (check null-ls documentation for available methods)
---@return table the available sources for the given filetype and method
function fignvim.lsp.none_ls.sources(filetype, method)
  local methods_avail, methods = pcall(require, "null-ls.methods")
  return methods_avail and fignvim.lsp.none_ls.providers(filetype)[methods.internal[method]] or {}
end

return fignvim.lsp.none_ls
