local gitsigns_mappings = {
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

return {
  {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPost",
    cmd = "Gitsigns",
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
      on_attach = function(bufnr)
        for _, keymap in ipairs(gitsigns_mappings) do
          local buf_specific_opts = fignvim.table.default_tbl({ buffer = bufnr }, keymap[4])
          vim.keymap.set(keymap[1], keymap[2], keymap[3], buf_specific_opts)
        end
      end,
    },
    config = function(_, opts)
      local gitsigns = require("gitsigns")
      local keymaps = gitsigns_mappings
      gitsigns.setup(opts)
      fignvim.mappings.register_whichkey_prefix("<leader>h", "Git Signs Hunk")
      fignvim.mappings.create_keymaps(keymaps)
    end,
  },
}
