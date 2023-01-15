local session_lens_keys = {
  {
    "n",
    "<leader>sl",
    function() require("session-lens").search_session() end,
    { desc = "Session Lens: Search for sessions using telescope" },
  },
}

local session_lens_spec = {
  "rmagatti/auto-session",
  event = "VeryLazy",
  keys = fignvim.config.make_lazy_keymaps(session_lens_keys, true),
  dependencies = {
    {
      "rmagatti/session-lens",
      opts = {
        path_display = { "shorten" },
        previewer = false,
      },
    },
    "telescope.nvim",
  },
  opts = {
    auto_save_enabled = false,
    auto_session_use_git_branch = false,
    cwd_change_handling = false,
  },
}

return {
  session_lens_spec,
}
