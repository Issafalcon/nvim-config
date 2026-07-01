vim.opt.rtp:prepend(vim.fn.stdpath("config") .. "/review-queue")

local ok, user_config = pcall(require, "review-queue-config")
require("review-queue").setup(ok and user_config or {})
