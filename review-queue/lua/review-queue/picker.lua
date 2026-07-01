local actions = require("review-queue.actions")
local config = require("review-queue._core.configuration")
local gh = require("review-queue.gh")
local repos = require("review-queue.repos")

local M = {}

---@param pr review_queue.PullRequest
---@return string
local function entry_text(pr)
  local local_path = repos.find_local_path(pr.repo)
  local marker = local_path and "" or " [clone]"
  return ("[%s] #%d %s%s"):format(pr.repo, pr.number, pr.title, marker)
end

---@param item snacks.picker.finder.Item
---@param picker snacks.Picker
---@return snacks.picker.Highlight[]
local function format_item(item, _picker)
  local pr = item.pr
  local ret = {} ---@type snacks.picker.Highlight[]
  local local_path = repos.find_local_path(pr.repo)
  local repo_hl = local_path and "Directory" or "WarningMsg"
  ret[#ret + 1] = { ("[%s]"):format(pr.repo), repo_hl }
  ret[#ret + 1] = { (" #%d "):format(pr.number), "Number" }
  ret[#ret + 1] = { pr.title }
  ret[#ret + 1] = { (" @%s"):format(pr.author), "Comment" }
  return ret
end

---@param ctx snacks.picker.preview.ctx
local function preview_pr(ctx)
  local pr = ctx.item.pr
  if not pr then
    return Snacks.picker.preview.none(ctx)
  end

  if pr.preview_text then
    ctx.item.preview = { text = pr.preview_text, ft = "markdown" }
    return Snacks.picker.preview.preview(ctx)
  end

  ctx.preview:set_lines({ "Loading PR overview…" })
  gh.fetch_pr_overview(pr, function(text)
    if ctx.preview.item ~= ctx.item then
      return
    end
    ctx.item.preview = { text = text, ft = "markdown" }
    Snacks.picker.preview.preview(ctx)
  end)
end

---@param prs review_queue.PullRequest[]
function M.open(prs)
  local cfg = config.get()

  Snacks.picker({
    title = "Review Queue",
    layout = cfg.picker.layout,
    finder = function()
      local items = {} ---@type snacks.picker.finder.Item[]
      for _, pr in ipairs(prs) do
        items[#items + 1] = {
          text = entry_text(pr),
          pr = pr,
        }
      end
      return items
    end,
    format = format_item,
    preview = preview_pr,
    confirm = function(picker, item)
      picker:close()
      if item and item.pr then
        actions.open_review(item.pr)
      end
    end,
  })
end

---@param on_done? fun(err?: string)
function M.open_async(on_done)
  local cfg = config.get()
  vim.notify("Fetching PRs awaiting your review…", vim.log.levels.INFO)

  gh.fetch_review_prs(cfg, function(err, prs)
    if err then
      vim.notify(err, vim.log.levels.ERROR)
      if on_done then
        on_done(err)
      end
      return
    end

    assert(prs)
    if #prs == 0 then
      vim.notify("No open pull requests are waiting for your review", vim.log.levels.INFO)
      if on_done then
        on_done()
      end
      return
    end

    M.open(prs)
    if on_done then
      on_done()
    end
  end)
end

return M
