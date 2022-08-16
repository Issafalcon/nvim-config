local M = {}

M.colors = {
  red = "#ca1243",
  grey = "#a0a1a7",
  black = "#383a42",
  white = "#f3f3f3",
  light_green = "#83a598",
  orange = "#fe8019",
  green = "#8ec07c",
  purple = "#5D3FD3",
}

function M.search_result()
  if vim.v.hlsearch == 0 then
    return ""
  end
  local last_search = vim.fn.getreg("/")
  if not last_search or last_search == "" then
    return ""
  end
  local searchcount = vim.fn.searchcount({ maxcount = 9999 })
  return last_search .. "(" .. searchcount.current .. "/" .. searchcount.total .. ")"
end

function M.modified()
  if vim.bo.modified then
    return "+"
  elseif vim.bo.modifiable == false or vim.bo.readonly == true then
    return "-"
  end
  return ""
end

function M.nvim_diagnostics_error()
  return {
    "diagnostics",
    source = { "nvim" },
    sections = { "error" },
    diagnostics_color = { error = { fg = M.colors.red } },
  }
end

function M.nvim_diagnostics_warn()
  return {
    "diagnostics",
    source = { "nvim" },
    sections = { "warn" },
    diagnostics_color = { warn = { fg = M.colors.orange } },
  }
end

return M
