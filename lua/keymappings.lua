local opts = { noremap = true, silent = true }
local maps = require("custom_config").mappings

local term_opts = { silent = true }

-- Shorten function name
local keymap = vim.api.nvim_set_keymap

--Remap space as leader key
keymap("", "<Space>", "<Nop>", opts)
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
keymap("n", maps.change_window.left, "<C-w>h", opts)
keymap("n", maps.change_window.down, "<C-w>j", opts)
keymap("n", maps.change_window.up, "<C-w>k", opts)
keymap("n", maps.change_window.right, "<C-w>l", opts)

-- Resize with arrows
keymap("n", maps.resize_window.up, ":resize +2<CR>", opts)
keymap("n", maps.resize_window.down, ":resize -2<CR>", opts)
keymap("n", maps.resize_window.left, ":vertical resize +2<CR>", opts)
keymap("n", maps.resize_window.right, ":vertical resize -2<CR>", opts)

-- Navigate buffers
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)

-- Quick close buffer
keymap("n", '<C-x>', ':bdelete<CR>', opts)

-- Insert --
-- Press jk fast to enter
keymap("i", "jk", "<ESC>", opts)

-- Visual --
-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Move text up and down
keymap("v", "<A-j>", ":m .+1<CR>==", opts)
keymap("v", "<A-k>", ":m .-2<CR>==", opts)

-- Visual Block --
-- Move text up and down
keymap("x", "J", ":move '>+1<CR>gv-gv", opts)
keymap("x", "K", ":move '<-2<CR>gv-gv", opts)
keymap("x", "<A-j>", ":move '>+1<CR>gv-gv", opts)
keymap("x", "<A-k>", ":move '<-2<CR>gv-gv", opts)
keymap('i', "<A-j>", '<Esc>:m .+1<CR>==gi', opts)
keymap('i', "<A-k>", '<Esc>:m .-2<CR>==gi', opts)
keymap("n", '<A-j>', ':m .+1<CR>==', opts)
keymap("n", '<A-k>', ':m .-2<CR>==', opts)

-- Line Numbers
keymap("n", "<leader>n", ":lua require('utils.UI').ToggleLineNumbers()<CR>", term_opts)
keymap("n", "<leader>rn", ":lua require('utils.UI').ToggleRelativeLineNumbers()<CR>", term_opts)
