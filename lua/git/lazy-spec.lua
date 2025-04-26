local gitsign_config = require("git.plugin-config.gitsigns")

return {
  {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPost",
    cmd = "Gitsigns",
    opts = gitsign_config.lazy_opts,
    config = gitsign_config.lazy_config,
  },
}
