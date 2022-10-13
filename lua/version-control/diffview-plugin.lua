-- Lua
local cb = require("diffview.config").diffview_callback
local maps = require("custom_config").mappings
local mapper = require("utils.mapper")

require("diffview").setup({
  diff_binaries = false, -- Show diffs for binaries
  file_panel = {
    win_config = {
      width = 35,
    },
  },
  use_icons = true, -- Requires nvim-web-devicons
  key_bindings = {
    disable_defaults = false, -- Disable the default key bindings
    -- The `view` bindings are active in the diff buffers, only when the current
    -- tabpage is a Diffview.
    view = {
      [maps.diffview.view.select_next_entry] = cb("select_next_entry"), -- Open the diff for the next file
      [maps.diffview.view.select_prev_entry] = cb("select_prev_entry"), -- Open the diff for the previous file
      [maps.diffview.view.focus_files] = cb("focus_files"), -- Bring focus to the files panel
      [maps.diffview.view.toggle_files] = cb("toggle_files"), -- Toggle the files panel.
    },
    file_panel = {
      ["j"] = cb("next_entry"), -- Bring the cursor to the next file entry
      ["<down>"] = cb("next_entry"),
      ["k"] = cb("prev_entry"), -- Bring the cursor to the previous file entry.
      ["<up>"] = cb("prev_entry"),
      ["<cr>"] = cb("select_entry"), -- Open the diff for the selected entry.
      ["o"] = cb("select_entry"),
      ["<2-LeftMouse>"] = cb("select_entry"),
      ["-"] = cb("toggle_stage_entry"), -- Stage / unstage the selected entry.
      ["S"] = cb("stage_all"), -- Stage all entries.
      ["U"] = cb("unstage_all"), -- Unstage all entries.
      ["X"] = cb("restore_entry"), -- Restore entry to the state on the left side.
      ["R"] = cb("refresh_files"), -- Update stats and entries in the file list.
      ["<tab>"] = cb("select_next_entry"),
      ["<s-tab>"] = cb("select_prev_entry"),
      ["<leader>e"] = cb("focus_files"),
      ["<leader>b"] = cb("toggle_files"),
    },
  },
})

mapper.map_virtual("n", maps.diffview.view.select_next_entry, "", "DiffView - View", "diffview_select_next_entry", "Opens the diff for the next file when in the View panel")
mapper.map_virtual("n", maps.diffview.view.select_prev_entry, "", "DiffView - View", "diffview_select_prev_entry", "Opens the diff for the previous file when in the View panel")
mapper.map_virtual("n", maps.diffview.view.focus_files, "", "DiffView - View", "diffview_focus_files", "Brings focus to the Files panel when in View panel")
