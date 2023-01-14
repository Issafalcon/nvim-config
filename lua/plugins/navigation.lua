local neo_tree_keys = {
  { "n", "<leader>e", ":Neotree toggle<CR>", { desc = "Open Neotree" } },
}

local rnvimr_keys = {
  { "n", "-", ":RnvimrToggle<CR>", { desc = "Rnvimr: Toggle Rnvimr" } },
}

local leap_keys = {
  { "n", "<C-m>", "<plug>(leap-forward-to)", { desc = "Leap: Forward to" } },
  { "n", "<C-n>", "<plug>(leap-backward-to)", { desc = "Leap: Backward to" } },
  { "n", "gs", "<plug>(leap-cross-window)", { desc = "Leap: Across all windows" } },
}

local neo_tree_spec = {
  "nvim-neo-tree/neo-tree.nvim",
  cmd = "NeoTree",
  keys = fignvim.config.make_lazy_keymaps(neo_tree_keys),
  init = function() vim.g.neo_tree_remove_legacy_commands = 1 end,
  opts = {
    close_if_last_window = true,
    enable_diagnostics = false,
    source_selector = {
      winbar = true,
      content_layout = "center",
      tab_labels = {
        filesystem = fignvim.ui.get_icon("FolderClosed") .. " File",
        buffers = fignvim.ui.get_icon("DefaultFile") .. " Bufs",
        git_status = fignvim.ui.get_icon("Git") .. " Git",
        diagnostics = fignvim.ui.get_icon("Diagnostic") .. " Diagnostic",
      },
    },
    default_component_configs = {
      indent = {
        padding = 0,
      },
      icon = {
        folder_closed = fignvim.ui.get_icon("FolderClosed"),
        folder_open = fignvim.ui.get_icon("FolderOpen"),
        folder_empty = fignvim.ui.get_icon("FolderEmpty"),
        default = fignvim.ui.get_icon("DefaultFile"),
      },
      git_status = {
        symbols = {
          added = fignvim.ui.get_icon("GitAdd"),
          deleted = fignvim.ui.get_icon("GitDelete"),
          modified = fignvim.ui.get_icon("GitChange"),
          renamed = fignvim.ui.get_icon("GitRenamed"),
          untracked = fignvim.ui.get_icon("GitUntracked"),
          ignored = fignvim.ui.get_icon("GitIgnored"),
          unstaged = fignvim.ui.get_icon("GitUnstaged"),
          staged = fignvim.ui.get_icon("GitStaged"),
          conflict = fignvim.ui.get_icon("GitConflict"),
        },
      },
    },
    window = {
      width = 30,
      mappings = {
        ["o"] = "open",
      },
    },
    filesystem = {
      follow_current_file = true,
      hijack_netrw_behavior = "open_current",
      use_libuv_file_watcher = true,
    },
    event_handlers = {
      {
        event = "neo_tree_buffer_enter",
        handler = function(_) vim.opt_local.signcolumn = "auto" end,
      },
    },
  },
}

local rnvimr_spec = {
  "kevinhwang91/rnvimr",
  cmd = "RnvimrToggle",
  enabled = function() return vim.fn.executable("ranger") == 1 end,
  keys = fignvim.config.make_lazy_keymaps(rnvimr_keys),
}

local leap_spec = {
  "ggandor/leap.nvim",
  event = "VeryLazy",
  keys = fignvim.config.make_lazy_keymaps(leap_keys),
}

return {
  neo_tree_spec,
  rnvimr_spec,
  leap_spec,
  aerial_spec,
}
