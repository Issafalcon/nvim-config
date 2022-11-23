fignvim.table = {}

--- Merge extended options with a default table of options
---@param opts table the new options that should be merged with the default table
---@param default table the default table that you want to merge into
---@return table the merged table
function fignvim.table.default_tbl(opts, default)
  opts = opts or {}
  return default and vim.tbl_deep_extend("force", default, opts) or opts
end

--- Calculates the index of the given value in the passed in array
---@param array table The array to search
---@param value any The value to look for
---@return
function fignvim.table.index_of(array, value)
  for i, v in ipairs(array) do
    if v == value then
      return i
    end
  end
  return nil
end

return fignvim.table
