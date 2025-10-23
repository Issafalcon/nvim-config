fignvim.path = {}

local sep = (function()
  ---@diagnostic disable-next-line: undefined-global
  if jit then
    ---@diagnostic disable-next-line: undefined-global
    local os = string.lower(jit.os)
    if os == "linux" or os == "osx" or os == "bsd" then
      return "/"
    else
      return "\\"
    end
  else
    return package.config:sub(1, 1)
  end
end)()

--- Joins a list of path components into a single path, using the correct separator for the current OS
---@param path_components string[]
---@return string
function fignvim.path.concat(path_components) return table.concat(path_components, sep) end

return fignvim.path
