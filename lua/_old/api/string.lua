fignvim.string = {}

--- Add left and/or right padding to a string
---@param str string the string to add padding to
---@param padding table a table of the format `{ left = 0, right = 0}` that defines the number of spaces to include to the left and the right of the string
---@return string the padded string
function fignvim.string.pad_string(str, padding)
  padding = padding or {}
  return str and str ~= "" and string.rep(" ", padding.left or 0) .. str .. string.rep(" ", padding.right or 0) or ""
end

--- Trim a string or return nil
---@param str string the string to trim
---@return string | nil a trimmed version of the string or nil if the parameter isn't a string
function fignvim.string.trim_or_nil(str)
  return type(str) == "string" and vim.trim(str) or nil
end

return fignvim.string
