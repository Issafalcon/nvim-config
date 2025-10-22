local pipeline_config = require("git.plugin-config.pipeline")
local git_messenger_config = require("git.plugin-config.git-messenger")

return {
  {
    "rhysd/git-messenger.vim",
    event = "VeryLazy",
  },

  {
    "topaxi/pipeline.nvim",
    --TODO: Add to keymaps
    keys = {
      { "<leader>gh", "<cmd>Pipeline<cr>", desc = "Open Pipeline" },
    },
    -- optional, you can also install and use `yq` instead.
    build = "make",
    opts = pipeline_config.lazy_opts,
  },

  {
    "rhysd/git-messenger.vim",
    event = "VeryLazy",
    init = git_messenger_config.lazy_init,
  },
}
