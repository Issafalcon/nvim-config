fignvim.fn = {}

--- Call function if a condition is met
---@param func function the function to run
---@param condition any a boolean value of whether to run the function or not
---@vararg any The arguments to be passed to the function
function fignvim.fn.conditional_func(func, condition, ...)
  -- if the condition is true or no condition is provided, evaluate the function with the rest of the parameters and return the result
  if (condition == nil or condition) and type(func) == "function" then
    return func(...)
  end
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

---@generic R
---@param fn fun():R?
---@param opts? string|{msg:string, on_error:fun(msg)}
---@return R
function fignvim.fn.try(fn, opts)
  opts = type(opts) == "string" and { msg = opts } or opts or {}
  local msg = opts.msg
  -- error handler
  local error_handler = function(err)
    msg = (msg and (msg .. "\n\n") or "") .. err .. M.pretty_trace()
    if opts.on_error then
      opts.on_error(msg)
    else
      vim.schedule(function()
        fignvim.ui.notifications.error(msg)
      end)
    end
    return err
  end

  ---@type boolean, any
  local ok, result = xpcall(fn, error_handler)
  return ok and result or nil
end

return fignvim.fn
