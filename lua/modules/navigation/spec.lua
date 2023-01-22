local neo_tree_keys = {
  { "n", "<leader>e", ":Neotree toggle<CR>", { desc = "Open Neotree" } },
}

local neo_tree_spec = {
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
  config = function(_, opts)
    local neotree = require("neo-tree").setup(opts)
    fignvim.mappings.register_keymap_group("Navigation", neo_tree_keys, false)
  end,
}

local rnvimr_keys = {
  { "n", "-", ":RnvimrToggle<CR>", { desc = "Rnvimr: Toggle Rnvimr" } },
}

local rnvimr_spec = {
  "kevinhwang91/rnvimr",
  cmd = "RnvimrToggle",
  init = function()
    fignvim.config.set_vim_opts({
      g = {
        rnvimr_enable_ex = 0, -- Replace netrw with ranger
        rnvimr_draw_border = 1, -- Draw border for ranger
        rnvimr_enable_picker = 1, -- Keep showing ranger after choosing a file
        rnvimr_edit_cmd = "edit", -- Edit file in current window
        rnvimr_enable_bw = 1, -- Make nvim wipe buffers corresponding to files deleted in Ranger
        rnvimr_border_attr = { fg = 14, bg = -1 }, -- Ranger border colour
        rnvimr_ranger_cmd = { "ranger", "--cmd=set draw_borders both" },
        rnvimr_action = {
          ["<C-i>"] = "NvimEdit tabedit",
          ["<C-x>"] = "NvimEdit split",
          ["<C-v>"] = "NvimEdit vsplit",
          ["gw"] = "JumpNvimCwd",
          ["yw"] = "EmitRangerCwd",
        }, -- Ranger keybindings
      },
    })
  end,
  enabled = function() return vim.fn.executable("ranger") == 1 end,
  keys = fignvim.mappings.make_lazy_keymaps(rnvimr_keys, true),
  config = function(_, opts) fignvim.mappings.register_keymap_group("Navigation", rnvimr_keys, false) end,
}

local leap_keys = {
  { "n", "<C-m>", "<plug>(leap-forward-to)", { desc = "Leap: Forward to" } },
  { "n", "<C-n>", "<plug>(leap-backward-to)", { desc = "Leap: Backward to" } },
  { "n", "gs", "<plug>(leap-cross-window)", { desc = "Leap: Across all windows" } },
}

local leap_spec = {
  "ggandor/leap.nvim",
  event = "VeryLazy",
  keys = fignvim.mappings.make_lazy_keymaps(leap_keys, true),
  config = function() fignvim.mappings.register_keymap_group("Navigation", leap_keys, false) end,
}

return fignvim.module.enable_registered_plugins({
  ["neo_tree"] = neo_tree_spec,
  ["rnvimr"] = rnvimr_spec,
  ["leap"] = leap_spec,
  ["telescope"] = require("modules.navigation.telescope"),
}, "navigation")
