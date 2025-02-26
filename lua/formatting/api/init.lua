fignvim.formatting = {}

---@class fignvim.formatting
---@overload fun(opts?: {force?:boolean})
fignvim.formatting = setmetatable({}, {
  __call = function(m, ...)
    return m.format(...)
  end,
})

---@class FigNvimFormatter
---@field name string
---@field primary? boolean
---@field format fun(bufnr:number)
---@field sources fun(bufnr:number):string[]
---@field priority number

---@type FigNvimFormatter[]
fignvim.formatting.formatters = {}

---@param formatter FigNvimFormatter
fignvim.formatting.register = function(formatter)
  fignvim.formatting.formatters[#fignvim.formatting.formatters + 1] = formatter
  table.sort(fignvim.formatting.formatters, function(a, b)
    return a.priority > b.priority
  end)
end

function fignvim.formatting.formatexpr()
  if fignvim.plug.get_plugin("conform.nvim") then
    return require("conform").formatexpr()
  end
  return vim.lsp.formatexpr({ timeout_ms = 3000 })
end

---@param buf? number
---@return (FigNvimFormatter|{active:boolean,resolved:string[]})[]
function fignvim.formatting.resolve(buf)
  buf = buf or vim.api.nvim_get_current_buf()
  local have_primary = false
  ---@param formatter FigNvimFormatter
  return vim.tbl_map(function(formatter)
    local sources = formatter.sources(buf)
    local active = #sources > 0 and (not formatter.primary or not have_primary)
    have_primary = have_primary or (active and formatter.primary) or false
    return setmetatable({
      active = active,
      resolved = sources,
    }, { __index = formatter })
  end, fignvim.formatting.formatters)
end

---@param buf? number
function fignvim.formatting.info(buf)
  buf = buf or vim.api.nvim_get_current_buf()
  local gaf = vim.g.autoformat == nil or vim.g.autoformat
  local baf = vim.b[buf].autoformat
  local enabled = fignvim.formatting.enabled(buf)
  local lines = {
    "# Status",
    ("- [%s] global **%s**"):format(gaf and "x" or " ", gaf and "enabled" or "disabled"),
    ("- [%s] buffer **%s**"):format(
      enabled and "x" or " ",
      baf == nil and "inherit" or baf and "enabled" or "disabled"
    ),
  }
  local have = false
  for _, formatter in ipairs(fignvim.formatting.resolve(buf)) do
    if #formatter.resolved > 0 then
      have = true
      lines[#lines + 1] = "\n# " .. formatter.name .. (formatter.active and " ***(active)***" or "")
      for _, line in ipairs(formatter.resolved) do
        lines[#lines + 1] = ("- [%s] **%s**"):format(formatter.active and "x" or " ", line)
      end
    end
  end
  if not have then
    lines[#lines + 1] = "\n***No formatters available for this buffer.***"
  end
  FigNvimVim[enabled and "info" or "warn"](
    table.concat(lines, "\n"),
    { title = "FigNvimFormat (" .. (enabled and "enabled" or "disabled") .. ")" }
  )
end

---@param buf? number
function fignvim.formatting.enabled(buf)
  buf = (buf == nil or buf == 0) and vim.api.nvim_get_current_buf() or buf
  local gaf = vim.g.autoformat
  local baf = vim.b[buf].autoformat

  -- If the buffer has a local value, use that
  if baf ~= nil then
    return baf
  end

  -- Otherwise use the global value if set, or true by default
  return gaf == nil or gaf
end

---@param buf? boolean
function fignvim.formatting.toggle(buf)
  fignvim.formatting.enable(not fignvim.formatting.enabled(), buf)
end

---@param enable? boolean
---@param buf? boolean
function fignvim.formatting.enable(enable, buf)
  if enable == nil then
    enable = true
  end
  if buf then
    vim.b.autoformat = enable
  else
    vim.g.autoformat = enable
    vim.b.autoformat = nil
  end
  fignvim.formatting.info()
end

---@param opts? {force?:boolean, buf?:number}
function fignvim.formatting.format(opts)
  opts = opts or {}
  local buf = opts.buf or vim.api.nvim_get_current_buf()
  if not ((opts and opts.force) or fignvim.formatting.enabled(buf)) then
    return
  end

  local done = false
  for _, formatter in ipairs(fignvim.formatting.resolve(buf)) do
    if formatter.active then
      done = true
      FigNvim.try(function()
        return formatter.format(buf)
      end, { msg = "Formatter `" .. formatter.name .. "` failed" })
    end
  end

  if not done and opts and opts.force then
    FigNvim.warn("No formatter available", { title = "FigNvimVim" })
  end
end
