---@class review_queue.PickerOpts
---@field layout? string

---@class review_queue.Config
---@field repos_dir string Directory where local clones are stored
---@field include_repos string[] If non-empty, only these owner/repo values are shown
---@field exclude_repos string[] owner/repo values to hide
---@field gh_cmd string GitHub CLI executable
---@field gh_user? string GitHub login; auto-detected when nil
---@field search_limit integer Maximum PRs to fetch from GitHub
---@field picker review_queue.PickerOpts

local DEFAULTS = {
  repos_dir = vim.fn.expand("~/repos"),
  include_repos = {},
  exclude_repos = {},
  gh_cmd = "gh",
  gh_user = nil,
  search_limit = 100,
  picker = {
    layout = "ivy",
  },
}

local M = {}
local _config = vim.deepcopy(DEFAULTS)

---@param opts? review_queue.Config
function M.set(opts)
  _config = vim.tbl_deep_extend("force", vim.deepcopy(DEFAULTS), opts or {})
end

function M.reset()
  _config = vim.deepcopy(DEFAULTS)
end

---@return review_queue.Config
function M.get()
  return _config
end

return M
