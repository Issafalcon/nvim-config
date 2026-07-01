local config = require("review-queue._core.configuration")
local repos = require("review-queue.repos")

local M = {}

---@param pr review_queue.PullRequest
function M.open_review(pr)
  local cfg = config.get()
  repos.ensure_local(pr.repo, function(err, path)
    if err or not path then
      vim.notify(err or ("could not resolve local path for %s"):format(pr.repo), vim.log.levels.ERROR)
      return
    end

    repos.chdir(path)

    local checkout = vim.system({
      cfg.gh_cmd,
      "pr",
      "checkout",
      tostring(pr.number),
      "-R",
      pr.repo,
    }, { cwd = path }):wait()

    if checkout.code ~= 0 then
      vim.notify(
        ("failed to checkout PR #%d: %s"):format(pr.number, (checkout.stderr or ""):gsub("%s+$", "")),
        vim.log.levels.ERROR
      )
      return
    end

    local group = vim.api.nvim_create_augroup("ReviewQueueReview", { clear = true })
    vim.api.nvim_create_autocmd("BufEnter", {
      group = group,
      pattern = "octo://*/pull/*",
      once = true,
      callback = function()
        vim.defer_fn(function()
          require("octo.reviews").start_review()
        end, 50)
      end,
    })

    require("octo.utils").get_pull_request(pr.number, pr.repo)
  end)
end

return M
