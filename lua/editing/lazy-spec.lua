local keymaps = require("keymaps").Editing
local grugfar_config = require("editing.plugin-config.grug-far")
local refactoring_config = require("editing.plugin-config.refactoring")
local mini_align_config = require("editing.plugin-config.mini-align")
local mini_pairs_config = require("editing.plugin-config.mini-pairs")
local cutlass_config = require("editing.plugin-config.cutlass")
local matchup_config = require("editing.plugin-config.vim-matchup")
local bqf_config = require("editing.plugin-config.bqf")

return {
  -- General editing tools
  {
    "echasnovski/mini.align",
    version = "*",
    event = "BufReadPre",
    opts = mini_align_config.lazy_opts,
    config = function(_, opts)
      require("mini.align").setup(opts)
    end,
  },

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

  -- Search and replace
  {
    -- https://github.com/MagicDuck/grug-far.nvim
    "MagicDuck/grug-far.nvim",
    opts = grugfar_config.lazy_opts,
    cmd = "GrugFar",
    keys = fignvim.mappings.make_lazy_keymaps({
      keymaps.SearchAndReplace,
    }, true),
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
