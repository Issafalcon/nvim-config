local session_lens_keys = {
  {
    "n",
    "<leader>tl",
    function() require("session-lens").search_session() end,
    { desc = "Session Lens: Search for sessions using telescope" },
  },
}

local autosession_spec = {
  "rmagatti/auto-session",
  lazy = false,
  init = function() fignvim.mappings.register_keymap_group("Navigation", session_lens_keys, false, "<leader>t") end,
  keys = fignvim.mappings.make_lazy_keymaps(session_lens_keys, true),
  dependencies = {
    "telescope.nvim",
  },
  opts = {
    auto_save_enabled = false,
    auto_session_use_git_branch = false,
    cwd_change_handling = false,
    session_lens = {
      path_display = { "shorten" },
      previewer = false,
    },
  },
}

return fignvim.module.enable_registered_plugins({
  ["auto-session"] = autosession_spec,
}, "session")
