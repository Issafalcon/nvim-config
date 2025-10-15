local treesitter_config = require("treesitter.plugin-config.treesitter")
local mini_ai_config = require("treesitter.plugin-config.mini-ai")

return {
  {
    "nvim-treesitter/nvim-treesitter",
    version = false,
    build = ":TSUpdate",
    event = "BufReadPost",
    opts = treesitter_config.lazy_opts,
    dependencies = {
      -- Enable treesitter playground
      "nvim-treesitter/playground",
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    event = "BufReadPost",
  },
  -- Auto-close HTML tags in various filetypes
  {
    "windwp/nvim-ts-autotag",
    event = "BufReadPost",
  },
  -- Provide context based commentstring
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    event = "BufReadPost",
    init = function()
      fignvim.config.set_vim_opts({
        g = {
          skip_ts_context_commentstring_module = true,
        },
      })
    end,
  },
  {
    "echasnovski/mini.ai",
    event = "VeryLazy",
    opts = mini_ai_config.lazy_opts,
    depends = {
      "nvim-treesitter/nvim-treesitter",
      "folke/which-key.nvim",
    },
    config = mini_ai_config.lazy_config,
  },
}
