local dv = fignvim.plug.load_module_file("diffview")
if not dv then
  return
end

local cb = require("diffview.config").diffview_callback

local mappings = fignvim.config.get_plugin_mappings("diffview.nvim", true)

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
      [mappings.dv_select_next_entry.lhs] = cb("select_next_entry"), -- Open the diff for the next file
      [mappings.dv_select_prev_entry.lhs] = cb("select_prev_entry"), -- Open the diff for the previous file
      [mappings.dv_focus_files.lhs] = cb("focus_files"), -- Bring focus to the files panel
      [mappings.dv_toggle_files.lhs] = cb("toggle_files"), -- Toggle the files panel.
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
      [mappings.dv_select_next_entry.lhs] = cb("select_next_entry"), -- Open the diff for the next file
      [mappings.dv_select_prev_entry.lhs] = cb("select_prev_entry"), -- Open the diff for the previous file
      [mappings.dv_focus_files.lhs] = cb("focus_files"), -- Bring focus to the files panel
      [mappings.dv_toggle_files.lhs] = cb("toggle_files"), -- Toggle the files panel.
    },
  },
})
