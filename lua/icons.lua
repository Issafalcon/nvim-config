local M = {}

M.ft = {
  octo = "",
}

M.lsp = {
  active = "",
  loaded = "",
  loading1 = "",
  loading2 = "",
  loading3 = "",
}

M.files = {
  file_modified = "",
  file_read_only = "",
  folder_closed = "",
  folder_empty = "",
  folder_open = "",
}

--- Diagnostic severities.
M.diagnostics = {
  ERROR = "",
  WARN = "",
  HINT = "",
  INFO = "",
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
M.symbol_kinds = {
  Array = "󰅪",
  Class = "",
  Color = "󰏘",
  Constant = "󰏿",
  Constructor = "",
  Enum = "",
  EnumMember = "",
  Event = "",
  Field = "󰜢",
  File = "󰈙",
  Folder = "󰉋",
  Function = "󰆧",
  Interface = "",
  Keyword = "󰌋",
  Method = "󰆧",
  Module = "",
  Operator = "󰆕",
  Property = "󰜢",
  Reference = "󰈇",
  Snippet = "",
  Struct = "",
  Text = "",
  TypeParameter = "",
  Unit = "",
  Value = "",
  Variable = "󰀫",
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
