local gitsigns = fignvim.plug.load_module_file("gitsigns")
if not gitsigns then
  return
end

fignvim.gitsigns = {}

-- Setup
gitsigns.setup({
  signs = {
    add = { text = "▎" },
    change = { text = "▎" },
    delete = { text = "▎" },
    topdelete = { text = "契" },
    changedelete = { text = "▎" },
  },
  signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
  numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
  linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
  word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
  watch_gitdir = {
    interval = 300,
    follow_files = true,
  },
  attach_to_untracked = true,
  current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
    delay = 500,
    ignore_whitespace = false,
  },
  current_line_blame_formatter_opts = {
    relative_time = false,
  },
  sign_priority = 6,
  update_debounce = 100,
  status_formatter = nil, -- Use default
  max_file_length = 40000,
  preview_config = {
    -- Options passed to nvim_open_win
    border = "single",
    style = "minimal",
    relative = "cursor",
    row = 0,
    col = 1,
  },
  yadm = {
    enable = false,
  },
  on_attach = function(bufnr)
    fignvim.plug.gitsigns_on_attach_cb(bufnr)
  end,
})

function fignvim.gitsigns.next_hunk()
  local gs = package.loaded.gitsigns
  if vim.wo.diff then
    return "]c"
  end
  vim.schedule(function()
    gs.next_hunk()
  end)
  return "<Ignore>"
end

function fignvim.gitsigns.prev_hunk()
  local gs = package.loaded.gitsigns
  if vim.wo.diff then
    return "[c"
  end
  vim.schedule(function()
    gs.prev_hunk()
  end)
  return "<Ignore>"
end

return fignvim.gitsigns
