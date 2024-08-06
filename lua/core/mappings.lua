local M = {}

M.Lists = {
  {
    "n",
    "<C-q>",
    function()
      fignvim.ui.toggle_fix_list(true)
    end,
    { desc = "Toggle quickfix window" },
  },
  {
    "n",
    "<leader>q",
    function()
      fignvim.ui.toggle_fix_list(false)
    end,
    { desc = "Toggle location list window" },
  },
}

M.Window = {
  { "n", "<C-h>", "<C-w>h", { desc = "Move to next window to the left" } },
  { "n", "<C-l>", "<C-w>l", { desc = "Move to next window to the right" } },
  { "n", "<C-j>", "<C-w>j", { desc = "Move to next window down" } },
  { "n", "<C-k>", "<C-w>k", { desc = "Move to next window up" } },
  { "n", "<C-Up>", ":resize +2<CR>", { desc = "Resize window horizontally up" } },
  { "n", "<C-Down>", ":resize -2<CR>", { desc = "Resize window horizontally down" } },
  {
    "n",
    "<C-Left>",
    ":vertical resize +2<CR>",
    { desc = "Resize window vertically to the left" },
  },
  {
    "n",
    "<C-Right>",
    ":vertical resize -2<CR>",
    { desc = "Resize window vertically to the right" },
  },
}

M.Terminal = {
  { "t", "<esc>", [[<C-\><C-n>]], { desc = "Enter normal mode in terminal" } },
}

M.Editing = {
  { "i", "jk", "<ESC>", { desc = "Escape insert mode" } },
  { "v", "<", "<gv", { desc = "Indent selection left" } },
  { "v", ">", ">gv", { desc = "Indent selection right" } },
  { { "n", "v" }, "<A-j>", ":m .+1<CR>==", { desc = "Move selected lines up" } },
  { { "n", "v" }, "<A-k>", ":m .-2<CR>==", { desc = "Move selected lines down" } },
  { "x", "J", ":move '>+1<CR>gv-gv", { desc = "Move current line up" } },
  { "x", "K", ":move '<-2<CR>gv-gv", { desc = "Move current line down" } },
  { "x", "<A-j>", ":move '>+1<CR>gv-gv", { desc = "Move current line up" } },
  { "x", "<A-K>", ":move '<-2<CR>gv-gv", { desc = "Move current line down" } },
  { "i", "<A-j>", "<Esc>:m .+1<CR>==gi", { desc = "Move current line up" } },
  { "i", "<A-K>", "<Esc>:m .-2<CR>==gi", { desc = "Move current line down" } },
  {
    "n",
    "<leader>bo",
    "<cmd>%bd|e#<cr>",
    { desc = "Close all buffers except the current one" },
  },

  -- Create new text objects
  {
    "o",
    "ie",
    ":exec 'normal! ggVG'<cr>",
    { desc = "Creates new text object to operate on entire buffer" },
  },
  {
    "o",
    "iv",
    ":exec 'normal! HVL'<cr>",
    { desc = "Creates new text object to operate on all text in view" },
  },
}

M.Navigation = {
  { "n", "<S-l>", ":bnext<CR>", { desc = "Move to next buffer" } },
  {
    "n",
    "<S-h>",
    ":bprevious<CR>",
    { desc = "Move to previous buffer" },
  },
  { "n", "<C-x>", ":bdelete<CR>", { desc = "Close current buffer" } },
  {
    "n",
    "<leader>l",
    function()
      fignvim.ui.toggle_line_numbers()
    end,
    { desc = "Toggle line numbers" },
  },
  {
    "n",
    "<leader>rn",
    function()
      fignvim.ui.toggle_relative_line_numbers()
    end,
    { desc = "Toggle relative line numbers" },
  },
  { "n", "\\m", "m", { desc = "Set a mark" } },
}

return M
