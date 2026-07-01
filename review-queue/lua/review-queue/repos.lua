local config = require("review-queue._core.configuration")

local M = {}

---@param path string
---@return boolean
local function is_git_repo(path)
  return vim.uv.fs_stat(path .. "/.git") ~= nil
end

---@param repo string owner/repo
---@param cfg? review_queue.Config
---@return string?
function M.find_local_path(repo, cfg)
  cfg = cfg or config.get()
  local owner, name = repo:match("^([^/]+)/(.+)$")
  if not owner or not name then
    return nil
  end

  local sep = package.config:sub(1, 1)
  local candidates = {
    cfg.repos_dir .. sep .. owner .. sep .. name,
    cfg.repos_dir .. sep .. name,
  }

  for _, path in ipairs(candidates) do
    if is_git_repo(path) then
      return vim.fn.fnamemodify(path, ":p")
    end
  end

  return nil
end

---@param repo string owner/repo
---@param cfg? review_queue.Config
---@return string
function M.default_clone_path(repo, cfg)
  cfg = cfg or config.get()
  local owner, name = repo:match("^([^/]+)/(.+)$")
  assert(owner and name, "invalid repo: " .. repo)
  local sep = package.config:sub(1, 1)
  return vim.fn.fnamemodify(cfg.repos_dir .. sep .. owner .. sep .. name, ":p")
end

---@param repo string owner/repo
---@param method "ssh"|"https"
---@param target string
---@return string?, string?
function M.clone_url(repo, method, target)
  local owner, name = repo:match("^([^/]+)/(.+)$")
  if not owner or not name then
    return nil, "invalid repo: " .. repo
  end

  local url = method == "ssh"
      and ("git@github.com:%s/%s.git"):format(owner, name)
    or ("https://github.com/%s/%s.git"):format(owner, name)

  local parent = vim.fn.fnamemodify(target, ":h")
  if vim.fn.isdirectory(parent) == 0 then
    vim.fn.mkdir(parent, "p")
  end

  local result = vim.system({ "git", "clone", url, target }):wait()
  if result.code ~= 0 then
    return nil, (result.stderr or "git clone failed"):gsub("%s+$", "")
  end

  return target
end

---@param repo string owner/repo
---@param on_ready fun(err?: string, path?: string)
function M.ensure_local(repo, on_ready)
  local cfg = config.get()
  local existing = M.find_local_path(repo, cfg)
  if existing then
    on_ready(nil, existing)
    return
  end

  local target = M.default_clone_path(repo, cfg)
  Snacks.picker.select({ "SSH", "HTTPS" }, { prompt = ("Clone %s using"):format(repo) }, function(choice)
    if not choice then
      on_ready("clone cancelled")
      return
    end

    local method = choice == "SSH" and "ssh" or "https"
    vim.notify(("Cloning %s via %s…"):format(repo, choice), vim.log.levels.INFO)
    vim.schedule(function()
      local path, err = M.clone_url(repo, method, target)
      on_ready(err, path)
    end)
  end)
end

---@param path string
function M.chdir(path)
  vim.cmd.cd({ args = { vim.fn.fnameescape(path) }, mods = { silent = true } })
end

return M
