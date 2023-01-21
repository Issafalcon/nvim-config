local gitsigns_spec = {
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
      for _, keymap in ipairs(require("modules.git.git_signs_keymaps")) do
        local buf_specific_opts = fignvim.table.default_tbl({ buffer = bufnr }, keymap[4])
        vim.keymap.set(keymap[1], keymap[2], keymap[3], buf_specific_opts)
      end
    end,
  },
  config = function(_, opts)
    local gitsigns = require("gitsigns")
    local keymaps = require("modules.git.git_signs_keymaps")
    gitsigns.setup(opts)
    fignvim.mappings.register_keymap_group("GitSigns", keymaps, false, "<leader>h")
  end,
}

--- Special mapping callback for git_signs so mappings are created per buffer during the on_attach callback
---@param bufnr number The buffer number to create mappings for
function fignvim.plug.gitsigns_on_attach_cb(bufnr)
  local plugin = "gitsigns.nvim"
  local mappings = fignvim.config.get_plugin_mappings(plugin)
  for _, map in pairs(mappings) do
    fignvim.config.create_mapping(map, bufnr)
  end
end

local diffview_spec = {
  "sindrets/diffview.nvim",
  cmd = "Diffview",
  event = "VeryLazy",
  config = true,
}

local git_messenger_spec = {
  "rhysd/git-messenger.vim",
  event = "VeryLazy",
}

local fugitive_spec = {
  "tpope/vim-fugitive",
  event = "VeryLazy",
}

return fignvim.module.enable_registered_plugins({
  ["gitsigns"] = gitsigns_spec,
  ["diffview"] = diffview_spec,
  ["vim-fugitive"] = fugitive_spec,
  ["git-messenger"] = git_messenger_spec,
}, "git")
