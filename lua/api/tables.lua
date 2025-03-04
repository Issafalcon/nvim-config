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

local function is_list(t)
  local i = 0
  for _ in pairs(t) do
    i = i + 1
    if t[i] == nil then
      return false
    end
  end
  return true
end

local function can_merge(v)
  return type(v) == "table" and (vim.tbl_isempty(v) or not is_list(v))
end

--- Merges the values similar to vim.tbl_deep_extend with the **force** behavior,
--- but the values can be any type, in which case they override the values on the left.
--- Values will me merged in-place in the first left-most table. If you want the result to be in
--- a new table, then simply pass an empty table as the first argument `vim.merge({}, ...)`
--- Supports clearing values by setting a key to `vim.NIL`
---@generic T
---@param ... T
---@return T
function fignvim.table.merge(...)
  local ret = select(1, ...)
  if ret == vim.NIL then
    ret = nil
  end
  for i = 2, select("#", ...) do
    local value = select(i, ...)
    if can_merge(ret) and can_merge(value) then
      for k, v in pairs(value) do
        ret[k] = fignvim.table.merge(ret[k], v)
      end
    elseif value == vim.NIL then
      ret = nil
    elseif value ~= nil then
      ret = value
    end
  end
  return ret
end

return fignvim.table
