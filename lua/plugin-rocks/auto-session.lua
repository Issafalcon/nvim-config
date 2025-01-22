local session_lens_keys = {
  {
    "n",
    "<leader>tl",
    function()
      require("session-lens").search_session()
    end,
    { desc = "Session Lens: Search for sessions using telescope" },
  },
}

-- https://github.com/rmagatti/auto-session
require("auto-session").setup({
  auto_save_enabled = false,
  auto_session_use_git_branch = false,
  cwd_change_handling = false,
  session_lens = {
    path_display = { "shorten" },
    previewer = false,
  },
})
