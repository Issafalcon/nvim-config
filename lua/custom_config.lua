local M = {}

M.mappings = {
  -- Navigate between windows in normal mode
  change_window = {
    up = '<C-k>',
    down = '<C-j>',
    left = '<C-h>',
    right = '<C-l>'
  },
  -- Resize window in normal mode
  resize_window = {
    up = '<C-Up>',
    down = '<C-Down>',
    left = '<C-Left>',
    right = '<C-Right>'
  },
  -- Toggle quickfix and loclist in normal mode
  toggle_lists = {
    quickfix = '<C-q>',
    loclist = '<leader>q'
  }
}

return M
