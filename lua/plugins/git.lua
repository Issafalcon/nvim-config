local gitsigns_keys = {
  {
    "n",
    "]c",
    function() fignvim.git.gitsigns.next_hunk() end,
    { desc = "Gitsigns: Next hunk", noremap = true, silent = true, buffer = true, expr = true },
  },
  {
    "n",
    "[c",
    function() fignvim.git.gitsigns.prev_hunk() end,
    { desc = "Gitsigns: Previous hunk", silent = true, buffer = true, expr = true },
  },
  {
    { "v", "n" },
    "<leader>hs",
    ":Gitsigns stage_hunk<CR>",
    { desc = "Gitsigns: Stage hunk", silent = true, buffer = true },
  },
  {
    { "v", "n" },
    "<leader>hr",
    ":Gitsigns reset_hunk<CR>",
    { desc = "Gitsigns: Reset hunk", silent = true, buffer = true },
  },
  {
    "n",
    "<leader>hS",
    "<cmd>Gitsigns stage_buffer<CR>",
    { desc = "Gitsigns: Stage buffer", silent = true, buffer = true },
  },
  {
    "n",
    "<leader>hu",
    "<cmd>Gitsigns undo_stage_hunk<CR>",
    { desc = "Gitsigns: Undo the last hunk or buffer staging command", silent = true, buffer = true },
  },
  {
    "n",
    "<leader>hR",
    "<cmd>Gitsigns reset_buffer<CR>",
    { desc = "Gitsigns: Reset the buffer", silent = true, buffer = true },
  },
  {
    "n",
    "<leader>hp",
    "<cmd>Gitsigns preview_hunk<CR>",
    { desc = "Gitsigns: Preview the hunk in floating window", silent = true, buffer = true },
  },
  {
    "n",
    "<leader>hb",
    "<cmd>lua require'gitsigns'.blame_line{full=true}<CR>",
    { desc = "Gitsigns: Show git blame of full change in floating window", silent = true, buffer = true },
  },
  {
    "n",
    "<leader>gB",
    "<cmd>Gitsigns toggle_current_line_blame<CR>",
    { desc = "Gitsigns: Toggle virtual text line blame", silent = true, buffer = true },
  },
  {
    "n",
    "<leader>hd",
    "<cmd>Gitsigns diffthis<CR>",
    { desc = "Gitsigns: Diff the current file against index", silent = true, buffer = true },
  },
  {
    "n",
    "<leader>hD",
    "<cmd>Gitsigns diffthis('main')<CR>",
    { desc = "Gitsigns: Diff the current file against main", silent = true, buffer = true },
  },
  {
    "n",
    "<leader>gd",
    "<cmd>Gitsigns toggle_deleted<CR>",
    { desc = "Gitsigns: Toggle deleted lines in buffer", silent = true, buffer = true },
  },
  {
    { "o", "x" },
    "ih",
    ":<C-U>Gitsigns select_hunk<CR>",
    { desc = "Gitsigns: Select the current hunk as a text object", silent = true, buffer = true },
  },
}

local diffview_spec = {
  "sindrets/diffview.nvim",
  cmd = "Diffview",
  event = "VeryLazy",
  config = true,
}

local gitsigns_spec = {
  "lewis6991/gitsigns.nvim",
  event = "BufReadPre",
  keys = fignvim.config.make_lazy_keymaps(gitsigns_keys, false),
  opts = {
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
    on_attach = function(bufnr) fignvim.plug.gitsigns_on_attach_cb(bufnr) end,
  },
  config = function(_, opts)
    local gitsigns = require("gitsigns")
    gitsigns.setup(opts)
    fignvim.config.register_keymap_group("GitSigns", gitsigns_keys, false, "<leader>h")
  end,
}

local git_messenger_spec = {
  "rhysd/git-messenger.vim",
  event = "VeryLazy",
}

local fugitive_spec = {
  "tpope/vim-fugitive",
  event = "VeryLazy",
}

return {
  diffview_spec,
  gitsigns_spec,
  git_messenger_spec,
  fugitive_spec,
}
