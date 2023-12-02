local neo_tree_keys = {
  { "n", "<leader>e", ":Neotree toggle<CR>", { desc = "Open Neotree" } },
}


return {{
  "nvim-neo-tree/neo-tree.nvim",
  cmd = "NeoTree",
  keys = fignvim.mappings.make_lazy_keymaps(neo_tree_keys, true),
  init = function() vim.g.neo_tree_remove_legacy_commands = 1 end,
  dependencies = {
    "plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
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
  config = function(_, opts) require("neo-tree").setup(opts) end,
}
}

