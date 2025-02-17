local M = {}

M.Core = {}

M.Core.Lists = {
  ToggleQuickFix = {
    "n",
    "<C-q>",
    function()
      fignvim.ui.toggle_fix_list(true)
    end,
    { desc = "Toggle quickfix window" },
  },
  ToggleLocationList = {
    "n",
    "<leader>q",
    function()
      fignvim.ui.toggle_fix_list(false)
    end,
    { desc = "Toggle location list window" },
  },
}

M.Core.Window = {
  MoveLeft = { "n", "<C-h>", "<C-w>h", { desc = "Move to next window to the left" } },
  MoveRight = { "n", "<C-l>", "<C-w>l", { desc = "Move to next window to the right" } },
  MoveDown = { "n", "<C-j>", "<C-w>j", { desc = "Move to next window down" } },
  MoveUp = { "n", "<C-k>", "<C-w>k", { desc = "Move to next window up" } },
  ResizeUp = { "n", "<C-Up>", ":resize +2<CR>", { desc = "Resize window horizontally up" } },
  ResizeDown = { "n", "<C-Down>", ":resize -2<CR>", { desc = "Resize window horizontally down" } },
  ResizeLeft = { "n", "<C-Left>", ":vertical resize +2<CR>", { desc = "Resize window vertically to the left" } },
  ResizeRight = { "n", "<C-Right>", ":vertical resize -2<CR>", { desc = "Resize window vertically to the right" } },
}

M.CoreTerminal = {
  NormalMode = { "t", "<esc>", [[<C-\><C-n>]], { desc = "Enter normal mode in terminal" } },
}

M.Core.Editing = {
  EscapeInsert = { "i", "jk", "<ESC>", { desc = "Escape insert mode" } },
  IndentSelectionLeft = { "v", "<", "<gv", { desc = "Indent selection left" } },
  IndentSelectionRight = { "v", ">", ">gv", { desc = "Indent selection right" } },
  MoveSelectedLinesUp = { { "n", "v" }, "<A-j>", ":m .+1<CR>==", { desc = "Move selected lines up" } },
  MoveSelectedLinesDown = { { "n", "v" }, "<A-k>", ":m .-2<CR>==", { desc = "Move selected lines down" } },
  MoveLineUp = { "x", { "J", "<A-j>" }, ":move '>+1<CR>gv-gv", { desc = "Move current line up" } },
  MoveLineDown = { "x", { "K", "A-k" }, ":move '<-2<CR>gv-gv", { desc = "Move current line down" } },
  MoveLineUpInInsert = { "i", "<A-j>", "<Esc>:m .+1<CR>==gi", { desc = "Move current line up" } },
  MoveLineDownInInsert = { "i", "<A-K>", "<Esc>:m .-2<CR>==gi", { desc = "Move current line down" } },
  CloseAllBuffersExceptCurrent = {
    "n",
    "<leader>bo",
    "<cmd>%bd|e#<cr>",
    { desc = "Close all buffers except the current one" },
  },

  -- Create new text objects
  TextObjectBuffer = {
    "o",
    "ie",
    ":exec 'normal! ggVG'<cr>",
    { desc = "Creates new text object to operate on entire buffer" },
  },
  TextObjectView = {
    "o",
    "iv",
    ":exec 'normal! HVL'<cr>",
    { desc = "Creates new text object to operate on all text in view" },
  },
}

M.Core.Navigation = {
  MoveNextBuffer = { "n", "<S-l>", ":bnext<CR>", { desc = "Move to next buffer" } },
  MovePreviousBuffer = { "n", "<S-h>", ":bprevious<CR>", { desc = "Move to previous buffer" } },
  CloseCurrentBuffer = { "n", "<C-x>", ":bdelete<CR>", { desc = "Close current buffer" } },
  ToggleLineNumbers = {
    "n",
    "<leader>l",
    function()
      fignvim.ui.toggle_line_numbers()
    end,
    { desc = "Toggle line numbers" },
  },
  ToggleRelativeLineNumbers = {
    "n",
    "<leader>rn",
    function()
      fignvim.ui.toggle_relative_line_numbers()
    end,
    { desc = "Toggle relative line numbers" },
  },
  SetMark = { "n", "\\m", "m", { desc = "Set a mark" } },
}

M.Completion = {
  SelectPrevItem = "<C-k>",
  SelectNextItem = "<C-j>",
  SelectPrevItemInsert = "<Up>",
  SelectNextItemInsert = "<Down>",
  ScrollDocsUp = "<C-b>",
  ScrollDocsDown = "<C-f>",
  Complete = "<C-space>",
  Disable = "<C-y>",
  Abort = "<C-e>",
  Confirm = "<CR>",
  AcceptCopilotSuggestion = "<C-x>",
  SuperTab = "<Tab>",
  SuperTabBack = "<S-Tab>",
}

return M
