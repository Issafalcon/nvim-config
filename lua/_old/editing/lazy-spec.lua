local keymaps = require("keymaps").Editing
local refactoring_config = require("editing.plugin-config.refactoring")
local dial_config = require("editing.plugin-config.dial")
local comment_config = require("editing.plugin-config.comment")

return {
  -- General editing tools
  {
    "numToStr/Comment.nvim",
    event = "BufReadPost",
    dependencies = {
      "JoosepAlviste/nvim-ts-context-commentstring",
    },
    config = comment_config.lazy_config,
  },

  -- Better increment / decrement
  {
    "monaqa/dial.nvim",
    keys = fignvim.mappings.make_lazy_keymaps({
      keymaps.DialIncrement,
      keymaps.DialDecrement,
    }, true),
    config = dial_config.lazy_config,
  },

  -- Refactoring
  {
    "ThePrimeagen/refactoring.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-telescope/telescope.nvim",
    },
    keys = fignvim.mappings.make_lazy_keymaps({
      keymaps.Refactor,
    }, true),
    opts = refactoring_config.lazy_opts,
    config = function(_, opts)
      require("refactoring").setup(opts)
      require("telescope").load_extension("refactoring")
    end,
  },
}
