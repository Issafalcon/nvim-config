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

return fignvim.fn
