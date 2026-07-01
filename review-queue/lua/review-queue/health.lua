local config = require("review-queue._core.configuration")
local gh = require("review-queue.gh")

local M = {}

function M.check()
  vim.health.start("review-queue")

  if vim.fn.executable("gh") == 0 then
    vim.health.error("gh CLI not found in PATH")
  else
    vim.health.ok("gh CLI available")
  end

  if vim.fn.executable("git") == 0 then
    vim.health.error("git not found in PATH")
  else
    vim.health.ok("git available")
  end

  local ok, octo = pcall(require, "octo")
  if not ok then
    vim.health.error("octo.nvim is not loaded")
  else
    vim.health.ok("octo.nvim loaded")
    if octo.setup then
      vim.health.ok("octo API available")
    end
  end

  local snacks_ok = pcall(require, "snacks.picker")
  if snacks_ok then
    vim.health.ok("snacks.picker available")
  else
    vim.health.error("snacks.picker not available")
  end

  local cfg = config.get()
  vim.health.info("repos_dir: " .. cfg.repos_dir)
  if vim.fn.isdirectory(cfg.repos_dir) == 1 then
    vim.health.ok("repos_dir exists")
  else
    vim.health.warn("repos_dir does not exist yet (it will be created on clone)")
  end

  local user, err = gh.current_user(cfg)
  if user then
    vim.health.ok("GitHub user: " .. user)
  else
    vim.health.error(err or "could not resolve GitHub user")
  end
end

return M
