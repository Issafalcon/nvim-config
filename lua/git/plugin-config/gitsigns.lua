local gitsigns_keymaps = require("keymaps").GitSigns

---@type FigNvimPluginConfig
local M = {}

M.lazy_opts = {
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
  on_attach = function(bufnr)
    for _, keymap in pairs(gitsigns_keymaps) do
      local buf_specific_opts = fignvim.table.default_tbl({ buffer = bufnr }, keymap[4])
      vim.keymap.set(keymap[1], keymap[2], keymap[3], buf_specific_opts)
    end
  end,
}

M.lazy_config = function(_, opts)
  local gitsigns = require("gitsigns")
  gitsigns.setup(opts)
  fignvim.mappings.register_whichkey_prefix("<leader>h", "Git Signs Hunk")
  fignvim.mappings.create_keymaps(gitsigns_keymaps)
end
return M
