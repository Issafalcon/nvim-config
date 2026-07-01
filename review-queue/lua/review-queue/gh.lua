local config = require("review-queue._core.configuration")

local M = {}

---@class review_queue.PullRequest
---@field number integer
---@field title string
---@field repo string owner/repo
---@field url string
---@field body string
---@field author string
---@field updated_at string
---@field preview_text? string

---@param repo string
---@return string
local function normalize_repo(repo)
  return repo:lower()
end

---@param repo string
---@param cfg review_queue.Config
---@return boolean
local function repo_allowed(repo, cfg)
  local key = normalize_repo(repo)

  for _, excluded in ipairs(cfg.exclude_repos) do
    if normalize_repo(excluded) == key then
      return false
    end
  end

  if #cfg.include_repos == 0 then
    return true
  end

  for _, included in ipairs(cfg.include_repos) do
    if normalize_repo(included) == key then
      return true
    end
  end

  return false
end

---@param cfg review_queue.Config
---@return string?, string?
function M.current_user(cfg)
  if cfg.gh_user and cfg.gh_user ~= "" then
    return cfg.gh_user
  end

  local result = vim.system({ cfg.gh_cmd, "api", "user", "-q", ".login" }):wait()
  if result.code ~= 0 then
    return nil, (result.stderr or "failed to resolve GitHub user"):gsub("%s+$", "")
  end

  local login = vim.trim(result.stdout or "")
  if login == "" then
    return nil, "GitHub user login is empty"
  end

  return login
end

---@param cfg review_queue.Config
---@param on_done fun(err?: string, prs?: review_queue.PullRequest[])
function M.fetch_review_prs(cfg, on_done)
  vim.schedule(function()
    local user, user_err = M.current_user(cfg)
    if not user then
      on_done(user_err)
      return
    end

    local query = ("review-requested:%s"):format(user)
    local result = vim.system({
      cfg.gh_cmd,
      "search",
      "prs",
      query,
      "--state",
      "open",
      "--limit",
      tostring(cfg.search_limit),
      "--json",
      "number,title,repository,url,updatedAt,author,body",
    }):wait()

    if result.code ~= 0 then
      on_done((result.stderr or "gh search prs failed"):gsub("%s+$", ""))
      return
    end

  ---@type { number: integer, title: string, repository: { nameWithOwner: string }, url: string, updatedAt: string, author: { login: string }, body: string }[]
    local ok, decoded = pcall(vim.json.decode, result.stdout)
    if not ok or type(decoded) ~= "table" then
      on_done("failed to decode gh search output")
      return
    end

    local prs = {} ---@type review_queue.PullRequest[]
    for _, item in ipairs(decoded) do
      local repo = item.repository and item.repository.nameWithOwner
      if repo and repo_allowed(repo, cfg) then
        prs[#prs + 1] = {
          number = item.number,
          title = item.title,
          repo = repo,
          url = item.url,
          body = item.body or "",
          author = item.author and item.author.login or "unknown",
          updated_at = item.updatedAt,
        }
      end
    end

    table.sort(prs, function(a, b)
      return a.updated_at > b.updated_at
    end)

    on_done(nil, prs)
  end)
end

---@param pr review_queue.PullRequest
---@param on_done fun(text: string)
function M.fetch_pr_overview(pr, on_done)
  if pr.preview_text then
    on_done(pr.preview_text)
    return
  end

  local cfg = config.get()
  vim.system({
    cfg.gh_cmd,
    "pr",
    "view",
    tostring(pr.number),
    "-R",
    pr.repo,
  }, {}, function(result)
    vim.schedule(function()
      local text = result.code == 0 and vim.trim(result.stdout or "") or ""
      if text == "" then
        text = M.format_fallback_preview(pr)
      end
      pr.preview_text = text
      on_done(text)
    end)
  end)
end

---@param pr review_queue.PullRequest
---@return string
function M.format_fallback_preview(pr)
  local lines = {
    ("#%d %s"):format(pr.number, pr.title),
    ("Repository: %s"):format(pr.repo),
    ("Author: @%s"):format(pr.author),
    ("Updated: %s"):format(pr.updated_at),
    ("URL: %s"):format(pr.url),
    "",
    pr.body,
  }
  return table.concat(lines, "\n")
end

return M
