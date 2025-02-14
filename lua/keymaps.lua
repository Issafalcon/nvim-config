local M = {}

M.Lists = {
  ToggleQuickFix = { keys = "<C-q>", mode = "n" },
  ToggleLocationList = { keys = "<leader>q", mode = "n" },
}

M.Window = {
  MoveLeft = { keys = "<C-h>", mode = "n" },
  MoveRight = { keys = "<C-l>", mode = "n" },
  MoveDown = { keys = "<C-j>", mode = "n" },
  MoveUp = { keys = "<C-k>", mode = "n" },
  ResizeUp = { keys = "<C-Up>", mode = "n" },
  ResizeDown = { keys = "<C-Down>", mode = "n" },
  ResizeLeft = { keys = "<C-Left>", mode = "n" },
  ResizeRight = { keys = "<C-Right>", mode = "n" },
}

M.Completion = {
  SuperTab = { keys = "<Tab>", mode = { "i", "s" } },
  SuperTabBack = { keys = "<S-Tab>", mode = { "i", "s" } },
  UndoBreakpointComma = { keys = ",", mode = "i" },
  UndoBreakpointPeriod = { keys = ".", mode = "i" },
  UndoBreakpointColon = { keys = ";", mode = "i" },
}

return M
