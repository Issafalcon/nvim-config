local session_lens_spec = {
  "rmagatti/auto-session",
  event = "VeryLazy",
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
