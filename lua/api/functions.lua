fignvim.fn = {}

--- Call function if a condition is met
---@param func function the function to run
---@param condition any a boolean value of whether to run the function or not
---@vararg any The arguments to be passed to the function
function fignvim.fn.conditional_func(func, condition, ...)
  -- if the condition is true or no condition is provided, evaluate the function with the rest of the parameters and return the result
  if (condition == nil or condition) and type(func) == "function" then return func(...) end
end

function fignvim.fn.put(...)
  local objects = {}
  for i = 1, select("#", ...) do
    local v = select(i, ...)
    table.insert(objects, vim.inspect(v))
  end

  print(table.concat(objects, "\n"))
  return ...
end

--- Check if a buffer is valid
-- @param bufnr the buffer to check
-- @return true if the buffer is valid or false
function fignvim.fn.is_valid_buffer(bufnr)
  if not bufnr or bufnr < 1 then return false end
  return vim.bo[bufnr].buflisted and vim.api.nvim_buf_is_valid(bufnr)
end

return fignvim.fn
