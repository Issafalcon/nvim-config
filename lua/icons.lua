local M = {}

M.ft = {
    octo = "",
}

--- Diagnostic severities.
M.diagnostics = {
    ERROR = '',
    WARN = '',
    HINT = '',
    INFO = '',
}

M.debug =
  {
    Stopped =  "󰁕 ",
    Breakpoint = " ",
    BreakpointCondition = " ",
    BreakpointRejected =  " ",
    LogPoint = ".>",
  },
-- Git
M.git = {
    added = " ",
    modified = " ",
    removed = " ",
  }

--- For folding.
M.arrows = {
    right = '',
    left = '',
    up = '',
    down = '',
}

--- LSP symbol kinds.
M.symbol_kinds = {
    Array = '󰅪',
    Class = '',
    Color = '󰏘',
    Constant = '󰏿',
    Constructor = '',
    Enum = '',
    EnumMember = '',
    Event = '',
    Field = '󰜢',
    File = '󰈙',
    Folder = '󰉋',
    Function = '󰆧',
    Interface = '',
    Keyword = '󰌋',
    Method = '󰆧',
    Module = '',
    Operator = '󰆕',
    Property = '󰜢',
    Reference = '󰈇',
    Snippet = '',
    Struct = '',
    Text = '',
    TypeParameter = '',
    Unit = '',
    Value = '',
    Variable = '󰀫',
}

--- Shared icons that don't really fit into a category.
M.misc = {
    bug = '',
    git = '',
    search = '',
    vertical_bar = '│',
    dots = "󰇘",
}

return M
