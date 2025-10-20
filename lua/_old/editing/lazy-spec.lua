local keymaps = require("keymaps").Editing
local refactoring_config = require("editing.plugin-config.refactoring")
local mini_pairs_config = require("editing.plugin-config.mini-pairs")
local cutlass_config = require("editing.plugin-config.cutlass")
local matchup_config = require("editing.plugin-config.vim-matchup")
local bqf_config = require("editing.plugin-config.bqf")
local dial_config = require("editing.plugin-config.dial")
local comment_config = require("editing.plugin-config.comment")

return {
  -- General editing tools
  {
    "echasnovski/mini.pairs",
    event = "VeryLazy",
    opts = mini_pairs_config.lazy_opts,
    config = mini_pairs_config.lazy_config,
  },

  {
    "andymass/vim-matchup",
    event = "BufReadPost",
    config = matchup_config.lazy_config,
  },
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

  -- Cut and paste
  {
    "gbprod/cutlass.nvim",
    lazy = false,
    opts = cutlass_config.lazy_opts,
  },

  {
    "kevinhwang91/nvim-bqf",
    lazy = false,
    init = bqf_config.lazy_init,
    keys = fignvim.mappings.make_lazy_keymaps(require("keymaps").Core.Lists, false),
    opts = bqf_config.lazy_opts,
  },
}
