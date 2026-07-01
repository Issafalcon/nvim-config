--- User configuration for review-queue
---@type review_queue.Config
return {
  repos_dir = vim.fn.expand("~/repos"),

  -- When non-empty, only PRs from these repositories are shown (owner/repo).
  include_repos = {
    -- "WatersConnectCloud/wcc-auditlog-viewer",
  },

  -- Repositories to hide even if you are requested as a reviewer.
  exclude_repos = {
    -- "WatersConnectCloud/wcc-env-config",
  },

  gh_cmd = "gh",
  -- gh_user = "your-github-login", -- auto-detected from `gh` when omitted
  search_limit = 100,

  picker = {
    layout = "ivy",
  },
}
