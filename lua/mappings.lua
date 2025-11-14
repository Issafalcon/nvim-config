local map = vim.keymap.set

map("", "<Space>", "<Nop>", { silent = true }) -- Prep for space to be leader key

-- Lists
map("n", "<C-q>", function()
  fignvim.ui.toggle_fix_list(true)
end, { desc = "Toggle quickfix window" })

map("n", "<leader>q", function()
  fignvim.ui.toggle_fix_list(false)
end, { desc = "Toggle location list window" })

-- Window
map("n", "<C-h>", "<C-w>h", { desc = "Move to next window to the left" })
map("n", "<C-l>", "<C-w>l", { desc = "Move to next window to the right" })
map("n", "<C-j>", "<C-w>j", { desc = "Move to next window down" })
map("n", "<C-k>", "<C-w>k", { desc = "Move to next window up" })
map("n", "<C-Up>", ":resize +2<CR>", { desc = "Resize window horizontally up" })
map("n", "<C-Down>", ":resize -2<CR>", { desc = "Resize window horizontally down" })
map("n", "<C-Left>", ":vertical resize +2<CR>", { desc = "Resize window vertically to the left" })
map("n", "<C-Right>", ":vertical resize -2<CR>", { desc = "Resize window vertically to the right" })

-- Terminal
map("t", "<esc>", "<C-\\><C-n>", { desc = "Enter normal mode in terminal" })

-- Editing
map("i", "jk", "<ESC>", { desc = "Escape insert mode" })
map("v", "<", "<gv", { desc = "Indent selection left" })
map("v", ">", ">gv", { desc = "Indent selection right" })
map({ "n", "v" }, "<A-j>", ":m .+1<CR>==", { desc = "Move selected lines up" })
map({ "n", "v" }, "<A-k>", ":m .-2<CR>==", { desc = "Move selected lines down" })
map("x", "J", ":move '>+1<CR>gv-gv", { desc = "Move current line up" })
map("x", "<A-j>", ":move '>+1<CR>gv-gv", { desc = "Move current line up" })
map("x", "K", ":move '<-2<CR>gv-gv", { desc = "Move current line down" })
map("x", "A-k", ":move '<-2<CR>gv-gv", { desc = "Move current line down" })
map("i", "<A-j>", "<Esc>:m .+1<CR>==gi", { desc = "Move current line up" })
map("i", "<A-K>", "<Esc>:m .-2<CR>==gi", { desc = "Move current line down" })
map("n", "<leader>bo", "<cmd>%bd|e#<cr>", { desc = "Close all buffers except the current one" })

map("o", "ie", ":exec 'normal! ggVG'<cr>", { desc = "Creates new text object to operate on entire buffer" })
map("o", "iv", ":exec 'normal! HVL'<cr>", { desc = "Creates new text object to operate on all text in view" })

-- Navigation
map("n", "<S-l>", ":bnext<CR>", { desc = "Move to next buffer" })
map("n", "<S-h>", ":bprevious<CR>", { desc = "Move to previous buffer" })

map("n", "<leader>ln", function()
  fignvim.ui.toggle_line_numbers()
end, { desc = "Toggle line numbers" })

map("n", "<leader>rn", function()
  fignvim.ui.toggle_relative_line_numbers()
end, { desc = "Toggle relative line numbers" })

map("n", "\\m", "m", { desc = "Set a mark" })
