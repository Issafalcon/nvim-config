local gitsign_config = require("git.plugin-config.gitsigns")
local octo_config = require("git.plugin-config.octo")
local pipeline_config = require("git.plugin-config.pipeline")
local git_messenger_config = require("git.plugin-config.git-messenger")

return {
  {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPost",
    cmd = "Gitsigns",
    opts = gitsign_config.lazy_opts,
    config = gitsign_config.lazy_config,
  },
  {
    "sindrets/diffview.nvim",
    cmd = "Diffview",
    event = "VeryLazy",
    config = true,
  },
  {
    "rhysd/git-messenger.vim",
    event = "VeryLazy",
  },

  {
    "pwntester/octo.nvim",
    event = "BufEnter",
    dependencies = {
      "plenary.nvim",
      "telescope.nvim",
      -- OR 'ibhagwan/fzf-lua',
      "nvim-web-devicons",
    },
    config = octo_config.lazy_config,
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
