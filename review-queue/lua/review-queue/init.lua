---@class review_queue
local M = {}

local config = require("review-queue._core.configuration")
local picker = require("review-queue.picker")

---@param opts? review_queue.Config
function M.setup(opts)
  config.set(opts)

  vim.api.nvim_create_user_command("ReviewQueue", function()
    picker.open_async()
  end, { desc = "List open PRs awaiting your review" })
end

function M.open()
  picker.open_async()
end

return M
