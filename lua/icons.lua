local M = {}

M.files = {
  file_modified = "",
  file_read_only = "",
  folder_closed = "",
  folder_empty = "",
  folder_open = "",
}

--- Diagnostic severities.
M.diagnostics = {
  error = "",
  warn = "",
  hint = "",
  info = "",
}

M.debug = {
  Stopped = "󰁕 ",
  Breakpoint = " ",
  BreakpointCondition = " ",
  BreakpointRejected = " ",
  LogPoint = ".>",
}

-- Git
M.git = {
  added = " ",
  modified = " ",
  removed = " ",
  git_branch = "",
  git_conflict = "",
  git_ignored = "◌",
  git_renamed = "➜",
  git_staged = "✓",
  git_unstaged = "✗",
  git_untracked = "★",
}

--- For folding.
M.arrows = {
  right = "",
  left = "",
  up = "",
  down = "",
}

--- LSP symbol kinds.
M.lsp = {
  array = "󰅪",
  class = "",
  color = "󰏘",
  constant = "󰏿",
  constructor = "",
  enum = "",
  enummember = "",
  event = "",
  field = "󰜢",
  file = "󰈙",
  folder = "󰉋",
  ["function"] = "󰆧",
  interface = "",
  keyword = "󰌋",
  method = "󰆧",
  module = "",
  operator = "󰆕",
  property = "󰜢",
  reference = "󰈇",
  snippet = "",
  struct = "",
  text = "",
  typeparameter = "",
  unit = "",
  value = "",
  variable = "󰀫",
  active = "",
  loaded = "",
  loading1 = "",
  loading2 = "",
  loading3 = "",
}

--- Shared icons that don't really fit into a category.
M.misc = {
  bug = "",
  git = "",
  search = "",
  vertical_bar = "│",
  dots = "󰇘",
  macro_recording = "",
  selected = "",
  vim_icon = "",
}

return M
