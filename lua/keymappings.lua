local opts = { noremap = true, silent = true }
local maps = require("custom_config").mappings
local mapper = require("utils.mapper")

local term_opts = { silent = true }

--Remap space as leader key
vim.api.nvim_set_keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- Normal --
-- Better window navigation
mapper.map("n", maps.change_window.left, "<C-w>h", opts, "Window", "window_left", "Move to next window to the left")
mapper.map("n", maps.change_window.right, "<C-w>l", opts, "Window", "window_right", "Move to next window to the right")
mapper.map("n", maps.change_window.down, "<C-w>j", opts, "Window", "window_down", "Move to next window down")
mapper.map("n", maps.change_window.up, "<C-w>k", opts, "Window", "window_up", "Move to next window up")

-- Resize with arrows
mapper.map(
  "n",
  maps.resize_window.up,
  ":resize +2<CR>",
  opts,
  "Window",
  "window_resize_up",
  "Resize window horizontally up"
)
mapper.map(
  "n",
  maps.resize_window.down,
  ":resize -2<CR>",
  opts,
  "Window",
  "window_resize_down",
  "Resize window horizontanlly down"
)
mapper.map(
  "n",
  maps.resize_window.left,
  ":vertical resize +2<CR>",
  opts,
  "Window",
  "window_resize_left",
  "Resize window vertically to the left"
)
mapper.map(
  "n",
  maps.resize_window.right,
  ":vertical resize -2<CR>",
  opts,
  "Window",
  "window_resize_right",
  "Resize window vertically to the right"
)

-- Navigate buffers
mapper.map("n", maps.navigation.buf_next, ":bnext<CR>", opts, "Navigation", "buf_next", "Move to next buffer")
mapper.map("n", maps.navigation.buf_prev, ":bprevious<CR>", opts, "Navigation", "buf_prev", "Move to previous buffer")

-- Quick close buffer
mapper.map("n", maps.navigation.buf_close, ":bdelete<CR>", opts, "Navigation", "buf_close", "Close current buffer")

-- Insert --
-- Press jk fast to enter
mapper.map(
  "i",
  maps.editing.escape_insert,
  "<ESC>",
  opts,
  "Editing",
  "escape_insert",
  "Escape insert mode, alternative binding"
)

-- Visual --
-- Stay in indent mode
mapper.map("v", maps.editing.indent_left, "<gv", opts, "Editing", "indent_left", "Indent selected text to the left")
mapper.map(
  "v",
  maps.editing.indent_right,
  ">gv",
  opts,
  "Edititing",
  "indent_right",
  "Indent selected text to the right"
)

-- Move text up and down
mapper.map(
  "v",
  maps.editing.move_text_up,
  ":m .+1<CR>==",
  opts,
  "Editing",
  "move_selection_up",
  "Move selected text up one line"
)
mapper.map(
  "v",
  maps.editing.move_text_down,
  ":m .-2<CR>==",
  opts,
  "Editing",
  "move_selection_down",
  "Move selected text down one line"
)

-- Visual Block --
-- Move text up and down
mapper.map(
  "x",
  maps.editing.move_text_up_alt,
  ":move '>+1<CR>gv-gv",
  opts,
  "Editing",
  "move_selection_up_alt",
  "Move selected text up one line"
)
mapper.map(
  "x",
  maps.editing.move_text_down_alt,
  ":move '<-2<CR>gv-gv",
  opts,
  "Editing",
  "move_selection_down_alt",
  "Move selected text down one line"
)
mapper.map(
  "x",
  maps.editing.move_text_up,
  ":move '>+1<CR>gv-gv",
  opts,
  "Editing",
  "move_selection_up_x",
  "Move selected text up one line"
)
mapper.map(
  "x",
  maps.editing.move_text_down,
  ":move '<-2<CR>gv-gv",
  opts,
  "Editing",
  "move_selection_down_x",
  "Move selected text down one line"
)
mapper.map(
  "i",
  maps.editing.move_text_up,
  "<Esc>:m .+1<CR>==gi",
  opts,
  "Editing",
  "move_line_up",
  "Move text on the current line up one line"
)
mapper.map(
  "i",
  maps.editing.move_text_down,
  "<Esc>:m .-2<CR>==gi",
  opts,
  "Editing",
  "move_line_down",
  "Move text on the current line down one line"
)
mapper.map(
  "n",
  maps.editing.move_text_up,
  ":m .+1<CR>==",
  opts,
  "Editing",
  "move_line_up_n",
  "Move text on the current line up one line"
)
mapper.map(
  "n",
  maps.editing.move_text_down,
  ":m .-2<CR>==",
  opts,
  "Editing",
  "move_line_down_n",
  "Move text on the current line down one line"
)

-- Line Numbers
mapper.map(
  "n",
  maps.navigation.toggle_line_nums,
  ":lua require('utils.UI').ToggleLineNumbers()<CR>",
  term_opts,
  "Navigation",
  "toggle_line_nums",
  "Toggle line numbers"
)
mapper.map(
  "n",
  maps.navigation.toggle_relative_line_nums,
  ":lua require('utils.UI').ToggleRelativeLineNumbers()<CR>",
  term_opts,
  "Navigation",
  "toggle_relative_line_nums",
  "Toggle relative line numbers"
)

-- Use non-yank register for character deletes
mapper.map("n", "x", '"_x', opts, "Editing", "delete_char", "Delete character override, preventing it from occupying yank register")
